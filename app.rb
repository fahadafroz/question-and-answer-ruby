#
# Copyright IBM Corp. 2014
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'sinatra'
require 'json'
require 'excon'

configure do
  service_name = "question_and_answer"

  endpoint = Hash.new

  set :endpoint, "<service_url>"
  set :username, "<service_username>"
  set :password, "<service_password>"

  if ENV.key?("VCAP_SERVICES")
    services = JSON.parse(ENV["VCAP_SERVICES"])
    if !services[service_name].nil?
      credentials = services[service_name].first["credentials"]
      set :endpoint, credentials["url"]
      set :username, credentials["username"]
      set :password, credentials["password"]
    else
      puts "The service #{service_name} is not in the VCAP_SERVICES, did you forget to bind it?"
    end
  end

  # Add a trailing slash, if it's not there
  unless settings.endpoint.end_with?('/')
    settings.endpoint = settings.endpoint + '/'
  end

  puts "endpoint = #{settings.endpoint}"
  puts "username = #{settings.username}"
end


get '/' do
  erb :index
end


post '/' do
  @dataset = params[:dataset]
  @questionText = params[:questionText];

  begin
    @answers = askWatson(@questionText, @dataset)
  rescue Exception => e
    @error = 'Error processing the request, please try again later.'
    puts  e.message
    puts  e.backtrace.join("\n")
  end

  erb :index
end


helpers do

  def askWatson(question, dataset)
    content = {
      :question => {
        :questionText => question,
        :evidenceRequest => { :items => 5}
      }
    }

    headers= {
      "Content-Type" => "application/json",
      "X-SyncTimeout" => "30"
    }

    response = Excon.post(settings.endpoint + "v1/question/"+ dataset,
      :body => content.to_json,
      :headers => headers,
      :user => settings.username,
      :password => settings.password)

    # Get the results from the first pipeline only
    pipeline = JSON.load(response.body)[0]
    answers_json = pipeline['question']['evidencelist']
    format_answers(answers_json)
  end


  def format_answers(results)
    new_results =[]
    if !results.nil?
      results.each { |result|
        new_result = result
        new_result['confidence'] = "#{(new_result['value'].to_f * 100).to_i} %"
        new_result['text'] = new_result['text']
        new_results = new_results << new_result
      }
    end
    new_results
  end

end