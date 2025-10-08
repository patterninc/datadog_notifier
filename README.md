# Datadog Notifier
### Send Custom Errors from Rails application to Dadatdog Error Tracking Dashboard

# Steps

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'datadog_notifier'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install datadog_notifier

### Dependency
* [Datadog](https://github.com/DataDog/dd-trace-rb) must be integrated in the project before we use this gem
* use version <=1.0.4 for ruby <3.4
# Quick Use
## Send notification to datadog(Traces to add errors in Datadog)
```DatadogNotifier.notify(exception, payload_json)```

Here `exception` is the error same as we send for Airbrake i.e `ErrorTracking.notify(exception)` and `payload_json` is an optional parameter where we can pass the payload(json value) to share extra details in datadog error tracking

## Error Tracking Dashboard link
- [Error Tracking](https://app.datadoghq.com/apm/error-tracking)
- We can filter out these custom errors using `@custom_dd_notifier:true` as we are passing this custom_dd_notifier while sending custom errors to datadog.


## Replace existing custom ErrorTracking with DatadogNotifier
We have kept DatadogNotifier signature same as other ErrorTracking services. This will help us to just search and replace all occurences.
Just replace **ErrorTracking.notify** with **DatadogNotifier.notify**
```
Before: ErrorTracking.notify("ProductErrorForm: Error while scraping new product", error_params_json)
After: DatadogNotifier.notify("ProductErrorForm: Error while scraping new product", error_params_json)
```

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/patterninc/datadog_notifier

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
