require 'ostruct'

module PuppetModule
  module Pkg
    class Tasks
      class Modulefile
        def self.parse(file)
          self.new(File.read(file)).metadata
        end

        attr_reader :metadata

        def initialize(str)
          @metadata = OpenStruct.new
          binding.eval str
        end

        private

        def name(s)
          @metadata.author, @metadata.name = s.split '/'
        end

        def version(s)
          @metadata.version = s
        end
      end
    end
  end
end
