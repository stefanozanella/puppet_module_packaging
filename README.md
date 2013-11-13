# Puppet Module Packaging

[![Build Status](https://travis-ci.org/stefanozanella/puppet_module_packaging.png?branch=master)](https://travis-ci.org/stefanozanella/puppet_module_packaging)
[![Gem Version](https://badge.fury.io/rb/puppet_module_packaging.png)](http://badge.fury.io/rb/puppet_module_packaging)
[![Dependency Status](https://gemnasium.com/stefanozanella/puppet_module_packaging.png)](https://gemnasium.com/stefanozanella/puppet_module_packaging)

Provides Rake tasks to ease shipping of Puppet modules as proper system
packages.

Currently, it provides tasks to build Debian and RPM packages. To do that, it
uses excellent Jordan Sissel's [fpm](https://github.com/jordansissel/fpm).

**NOTE**: at this stage, this library lacks a bunch of useful features
(particularly, its behavior can't be customized in any way and there's no
dependency management). Feel free to
submit issues or PRs if there's something that could help you out and you'd
like to see integrated.

## Installation

Add this line to your application's Gemfile:

    gem 'puppet_module_packaging'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install puppet_module_packaging

## Usage

To have the shipped Rake tasks available for your module, just add the
following lines to your `Rakefile`:

    require 'puppet_module/pkg/rake_task'

    PuppetModule::Pkg::Tasks.new

This will add the following tasks to your set:

* `install`
* `clean`
* `deb`
* `rpm`

To package your module, you only need to call the `deb` or `rpm` one.
The package will be output into the `pkg` folder; you can see the packaged
content into the `build` folder. _Package name_ will respect the following
format:

    puppet-mod-<author>-<module_name>

The information needed to build the package are carved out from the
`Modulefile`. In particular, there must be a `name` and a `version` field; the
first one must be in the form `author/module_name`. All other fields are
optional and are mapped into package fields with equivalent meaning.

**NOTE**: The module will be installed under `/usr/share/puppet/modules`, not
into `/etc/puppet`!

## Compatibility

OS compatibility resembles the one of FPM; in particular:

* on **OS X**, only Debian packages can be built
* in order to create RPMs on other platforms, the `rpmbuild` command must be
  present on the system. This can be obtained with:
  * `apt-get install rpm` (Debian-based)
  * `yum install rpm-build` (RedHat-based)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Testing

Executed tests vary depending on tools availability. In particular, end-to-end
tests involving generation of an RPM package are not run if `rpmbuild` is not
found on the system. To ease development, a `Vagrantfile` is provided, complete
with a Puppet manifest to configure the testing host. If you wish to run all
the tests without installing `rpmbuild`, you can just do the following:

    vagrant up
    vagrant ssh
    cd /vagrant
    bundle install --path vendor/bundle
    bundle exec rake test:all
