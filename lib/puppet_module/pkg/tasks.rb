require 'rake/tasklib'

module PuppetModule
  module Pkg
    class Tasks < Rake::TaskLib
      def initialize
        desc "Install the module in a local temp dir"
        task :install
      end
    end
  end
end
