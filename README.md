# datadog_notifier
## Send Custom errors from rails application to Dadatdog Error Tracking Dashboard

# Steps

## Installation

## Dependency
** [Datadog](https://github.com/DataDog/dd-trace-rb) must be integrated in the project before we use this gem


### Add this gem to your gemfile
``` gem 'datadog_notifier', git: 'https://github.com/patterninc/datadog_notifier.git'```

### bundle install
```bundle install```

## How to use
### Send notification to datadog(Traces to add errors in Datadog)
```DatadogNotifier.notify(exception, payload_json)```

Here `exception` is the error same as we send for Airbrake i.e `Airbrake.notify(exception)` and 
`payload_json` is an optional parameter where we can pass the payload(json value) to share extra details in error tracking

## Error Tracking Dashboard link
- https://app.datadoghq.com/apm/error-tracking
<img width="1465" alt="Screenshot 2023-12-20 at 11 42 17 AM" src="https://github.com/patterninc/datadog_notifier/assets/10542896/3e59ae58-6816-4d84-8421-a620f8c84133">

The errors shown in Dashboard can be seen in Datadog traces as well
- https://app.datadoghq.com/apm/trace/4712190923465835504?graphType=span_list&shouldShowLegend=true&sort=time&spanID=4712190923465835504&spanViewType=errors&view=spans
  <img width="1462" alt="Screenshot 2023-12-20 at 11 43 16 AM" src="https://github.com/patterninc/datadog_notifier/assets/10542896/849d0e83-65da-4e9b-ac48-1a5f3a834fc8">

## Replace Airbrake with DatadogNotifier
Just replace **Airbrake.notify** / **Airbrake.notify_sync** with **DatadogNotifier.notify**

Marketczar PR for reference - https://github.com/patterninc/marketczar/pull/115/commits/4a83e47ac621a630e9521f10bdadba7ca337f7a6
