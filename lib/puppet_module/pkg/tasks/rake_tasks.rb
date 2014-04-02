require 'rake/tasklib'

require 'puppet_module/pkg/tasks/system'
require 'puppet_module/pkg/tasks/module_finder'
require 'puppet_module/pkg/tasks/deb'
require 'puppet_module/pkg/tasks/rpm'
require 'puppet_module/pkg/tasks/install'
require 'puppet_module/pkg/tasks/clean'

module PuppetModule
  module Pkg
    class Tasks
      class RakeTasks < Rake::TaskLib
        def initialize(mod_info, custom_opts)
          sys = System.new
          options = OpenStruct.new({
            :install_dir      => 'build',
            :pkg_dir          => 'pkg',
            :dep_install_path => 'tmp/deps_inst',
            :dep_build_path   => 'tmp/deps_build',
            :recursive        => false
          }.merge(custom_opts))
          mod_finder = (options.recursive ? ModuleFinder : ModuleFinder::Disabled).new sys

          desc "Install the module in a local temp dir"
          task :install => :clean do
            Install.new(sys).invoke(mod_info, options)
          end

          desc "Clean build artifacts"
          task :clean do
            Clean.new(sys).invoke(mod_info, options)
          end

          desc "Wraps the module into a Debian package"
          task :deb => :install do
            Deb.new(sys, mod_finder).invoke(mod_info, options)
          end

          desc "Wraps the module into a RPM package"
          task :rpm => :install do
            RPM.new(sys, mod_finder).invoke(mod_info, options)
          end
        end
      end
    end
  end
end
