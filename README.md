# Question and Answer Ruby Sinatra Starter Application

  The IBM Watson [Question and Answer][question_and_answer] service interprets and answers user questions directly based on primary data sources (brochures, web pages, manuals, records, etc.) that have been selected and gathered into a body of data or 'corpus'. The service returns candidate responses with associated confidence levels and links to supporting evidence. The current corpora that are available in Bluemix focus on the Travel and Healthcare industries. Cognitive services learn and improve through training. This beta-level service has no training but shows representative (if not always highly accurate) output. The service is shared to demonstrate how it works. Training the models can improve the results through machine learning.

## Getting Started

1. Create a Bluemix Account

  [Sign up][sign_up] in Bluemix, or use an existing account. Watson Services in Beta are free to use.

2. Download and install the [Cloud-foundry CLI][cloud_foundry] tool

3. Edit the `manifest.yml` file and change the `<application-name>` to something unique.
  ```none
  applications:
  - services:
    - qa-service
    name: <application-name>
    path: .
    memory: 256M
  ```
  The name you use will determinate your application url initially, e.g. `<application-name>.mybluemix.net`.

4. Connect to Bluemix in the command line tool
  ```sh
  $ cf api https://api.ng.bluemix.net
  $ cf login -u <your user ID>
  ```

5. Create the Question and Answer service in Bluemix
  ```sh
  $ cf create-service question_and_answer question_and_answer_free_plan qa-service
  ```

6. Push it live!
  ```sh
  $ cf push <application-name>
  ```

See the full [Getting Started][getting_started] documentation for more details, including code snippets and references.

## License

  This sample code is licensed under Apache 2.0. Full license text is available in [LICENSE]: LICENSE).

## Contributing

  See [CONTRIBUTING](https://github.rtp.raleigh.ibm.com/gattana-us/qa-ruby/blob/master/CONTRIBUTING.md).

## Open Source @ IBM
  Find more open source projects on the [IBM Github Page](http://ibm.github.io/)

[question_and_answer]: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/qaapi/
[cloud_foundry]: https://github.com/cloudfoundry/cli
[getting_started]: http://www.ibm.com/smarterplanet/us/en/ibmwatson/developercloud/doc/getting_started/
[sign_up]: https://apps.admin.ibmcloud.com/manage/trial/bluemix.html?cm_mmc=WatsonDeveloperCloud-_-LandingSiteGetStarted-_-x-_-CreateAnAccountOnBluemixCLI