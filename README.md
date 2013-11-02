# Puppet Module Packaging

Provides Rake tasks to ease shipping of Puppet modules as proper system
packages.

Currently, it provides tasks to build Debian and RPM packages. To do that, it
uses the excellent Jordan Sissel's (https://github.com/jordansissel/fpm)[fpm].

## Installation

Add this line to your application's Gemfile:

    gem 'puppet_module_packaging'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install puppet_module_packaging

## Usage

To have the shipped Rake tasks available for your module, just add the
following line to your `Rakefile`:

    require 'puppet_module_packaging/rake_task'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
