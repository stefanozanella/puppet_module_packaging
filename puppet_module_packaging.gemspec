# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'pathname'
require 'puppet_module/pkg/version'

signing_key_file = ENV['RUBYGEMS_SIGNING_KEY_FILE']

Gem::Specification.new do |spec|
  spec.name          = "puppet_module_packaging"
  spec.version       = PuppetModule::Pkg::VERSION
  spec.authors       = ["Stefano Zanella"]
  spec.email         = ["zanella.stefano@gmail.com"]
  spec.summary       = %q{Rake tasks for packaging Puppet modules}
  spec.homepage      = "https://github.com/stefanozanella/puppet_module_packaging"
  spec.license       = "MIT"
  spec.description   = <<-EOS
    puppet_module_packaging provides some Rake tasks to ease wrapping Puppet
    modules into proper system packages like deb and rpm.
  EOS

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "fpm", "~> 0.4"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubygems-tasks"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-filesystem"
  spec.add_development_dependency "minitest-around"
  spec.add_development_dependency "mocha"

  spec.signing_key = Pathname.new(signing_key_file).expand_path if signing_key_file
  spec.cert_chain = ["rubygems-stefanozanella.crt"]
end
