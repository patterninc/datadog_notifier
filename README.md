# datadog_notifier
## Send Custom errors from rails application to Dadatdog Error Tracking Dashboard

# Steps
### Add this gem to your gemfile
``` gem 'datadog_notifier', git: 'https://github.com/patterninc/datadog_notifier.git'```
### bundle install
```bundle install```
### Send notification to datadog(Traces to add errors in Datadog)
```DatadogNotifier.notify(exception, payload_json)```

Here `exception` is the error same as we send for Airbrake i.e `Airbrake.notify(exception)`
`payload_json` is an optional parameter where we can pass the payload to error tracking
