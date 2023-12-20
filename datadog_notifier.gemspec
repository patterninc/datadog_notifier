Gem::Specification.new do |spec|
  spec.name          = 'datadog_notifier'
  spec.version       = '0.1.0'
  spec.summary       = 'Datadog notifier to send custom errors'
  spec.description   = 'Datadog notifier to send custom errors in Datadog error tracking dashboard'
  spec.authors       = ['Amol Udage']
  spec.email         = ['amol.udage@pattern.com']
  spec.files         = Dir['lib/**/*.rb']  # Include your Ruby file(s)
  # Add any additional dependencies
  spec.add_dependency 'ddtrace', '>= 1.13.0'

  # Specify the main file to require when the gem is loaded
  spec.require_paths = ['lib']
  spec.requirements << 'none'  # Add any requirements

  # If needed, add development dependencies
  spec.add_development_dependency 'rspec'
  # ... (other development dependencies)
end
