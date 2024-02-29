lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'datadog_notifier'
require "datadog_notifier/version"

Gem::Specification.new do |spec|
  spec.name          = 'datadog_notifier'
  spec.version       = DatadogNotifier::VERSION
  spec.authors       = ['Patterninc']
  spec.email         = ['amol.udage@pattern.com']
  spec.summary       = 'Datadog notifier to send custom errors with ddtrace'
  spec.description   = 'Datadog notifier to send custom errors in Datadog error tracking dashboard'
  spec.homepage      = 'https://github.com/patterninc/datadog_notifier'
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = ">= 2.7.0"

  spec.add_development_dependency "bundler", "~> 2.2.3"
  spec.add_development_dependency "rake", "~> 13.0"
 
  spec.add_dependency 'ddtrace', '>= 1.13.0'

  # If needed, add development dependencies
  spec.add_development_dependency 'rspec'
  # ... (other development dependencies)
end
