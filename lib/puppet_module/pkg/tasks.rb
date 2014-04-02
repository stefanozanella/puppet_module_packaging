require 'puppet_module/pkg/tasks/rake_tasks'
require 'puppet_module/pkg/tasks/modulefile'

module PuppetModule
  module Pkg
    class Tasks
      def initialize(options = {})
        RakeTasks.new(Modulefile.parse("Modulefile"), options)
      end
    end
  end
end
