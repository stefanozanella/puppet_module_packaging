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
          _, @metadata.name = s.split '/'
        end
      end
    end
  end
end
