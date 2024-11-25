puppet-lint-hiera_functions-check
=================================

[![License](https://img.shields.io/github/license/cbowman0/puppet-lint-hiera_functions-check.svg)](https://github.com/cbowman0/puppet-lint-hiera_functions-check/blob/master/LICENSE)
[![Test](https://github.com/cbowman0/puppet-lint-hiera_functions-check/actions/workflows/test.yml/badge.svg)](https://github.com/cbowman0/puppet-lint-hiera_functions-check/actions/workflows/test.yml)
[![Release](https://github.com/cbowman0/puppet-lint-hiera_functions-check/actions/workflows/release.yml/badge.svg)](https://github.com/cbowman0/puppet-lint-hiera_functions-check/actions/workflows/release.yml)
[![RubyGem Version](https://img.shields.io/gem/v/puppet-lint-hiera_functions-check.svg)](https://rubygems.org/gems/puppet-lint-hiera_functions-check)
[![RubyGem Downloads](https://img.shields.io/gem/dt/puppet-lint-hiera_functions-check.svg)](https://rubygems.org/gems/puppet-lint-hiera_functions-check)

A puppet-lint plugin to check for deprecated hiera() function usage

## Installing

### From the command line

```shell
$ gem install puppet-lint-hiera_functions-check
```

### In a Gemfile

```ruby
gem 'puppet-lint-hiera_functions-check', :require => false
```

## Checks

### Hiera function used

Usage of the hiera() function is deprecated

#### What you have done

```puppet
$key = hiera('key')
$key = hiera_array('key')
$key = hiera_hash('key')
$key = hiera_include('key')
```

#### What you should have done

```puppet
$key = lookup('key')
$key = lookup('key', {merge => unique})
$key = lookup('key', {merge => hash})
$key = lookup('key', {merge => unique}).include
```

#### Disabling the check

To disable this check, you can add `--no-hiera_functions-check` to your puppet-lint command line.

```shell
$ puppet-lint --no-hiera_functions-check path/to/file.pp
```

Alternatively, if you’re calling puppet-lint via the Rake task, you should insert the following line to your `Rakefile`.

```ruby
PuppetLint.configuration.send('disable_hiear_functions')
```

