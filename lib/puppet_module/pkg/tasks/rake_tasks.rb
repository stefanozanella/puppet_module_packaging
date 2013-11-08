require 'rake/tasklib'

require 'puppet_module/pkg/tasks/system'
require 'puppet_module/pkg/tasks/deb'
require 'puppet_module/pkg/tasks/install'
require 'puppet_module/pkg/tasks/clean'

module PuppetModule
  module Pkg
    class Tasks
      class RakeTasks < Rake::TaskLib
        def initialize(mod_info)
          sys = System.new
          options = OpenStruct.new(
            :install_dir => 'build',
            :pkg_dir     => 'pkg')

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
            Deb.new(sys).invoke(mod_info, options)
          end
        end
      end
    end
  end
end
