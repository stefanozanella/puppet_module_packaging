# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet_module_packaging/version'

Gem::Specification.new do |spec|
  spec.name          = "puppet_module_packaging"
  spec.version       = PuppetModulePackaging::VERSION
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

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
