require 'rake/tasklib'

module PuppetModule
  module Pkg
    class Tasks
      class RakeTasks < Rake::TaskLib
        def initialize(mod_info)
          desc "Install the module in a local temp dir"
          task :install do
            Install.new(FSDriver.new).invoke(mod_info.name, 'build')
          end
        end
      end
    end
  end
end
