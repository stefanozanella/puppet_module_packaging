require 'rake/tasklib'

require 'puppet_module/pkg/tasks/install'
require 'puppet_module/pkg/tasks/clean'

module PuppetModule
  module Pkg
    class Tasks
      class RakeTasks < Rake::TaskLib
        def initialize(mod_info)
          fs = FSDriver.new
          install_dir = 'build'

          desc "Install the module in a local temp dir"
          task :install => :clean do
            Install.new(fs).invoke(mod_info.name, install_dir)
          end

          desc "Clean build artifacts"
          task :clean do
            Clean.new(fs).invoke(install_dir)
          end
        end
      end
    end
  end
end
