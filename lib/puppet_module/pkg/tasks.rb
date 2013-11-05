require 'puppet_module/pkg/tasks/rake_tasks'
require 'puppet_module/pkg/tasks/install'
require 'puppet_module/pkg/tasks/fs_driver'
require 'puppet_module/pkg/tasks/modulefile'

module PuppetModule
  module Pkg
    class Tasks
      def initialize
        RakeTasks.new(Modulefile.parse("Modulefile"))
      end
    end
  end
end
