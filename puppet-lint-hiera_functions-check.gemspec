# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'puppet-lint-hiera_functions-check'
  spec.version     = '1.0.0'
  spec.homepage    = 'https://github.com/cbowman0/puppet-lint-hiera_functions-check'
  spec.license     = 'MIT'
  spec.author      = 'Christopher Bowman'
  spec.email       = 'cbowman0@gmail.com'
  spec.files       = Dir[
    'README.md',
    'LICENSE',
    'lib/**/*',
    'spec/**/*',
  ]
  spec.metadata = {
    'rubygems_mfa_required' => 'true'
  }
  spec.summary     = 'A puppet-lint plugin to check for deprecated hiera functions usage.'
  spec.description = <<-DESC
    A puppet-lint plugin to check for deprecated hieras function usage.

    The legacy Hiera functions (hiera, hiera_array, hiera_hash, and hiera_include) should be replaced with lookup()
  DESC

  spec.required_ruby_version = '>= 3.0.0'

  spec.add_dependency             'puppet-lint', '>= 1.1', '< 5.0'

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-collection_matchers', '~> 1.0'
  spec.add_development_dependency 'rspec-its', '~> 2.0'
  spec.add_development_dependency 'rspec-json_expectations', '~> 2.2'
  spec.add_development_dependency 'voxpupuli-rubocop', '~> 3.0'
end
