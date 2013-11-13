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
          validate_required_fields
        end

        private

        def name(s)
          @metadata.author, @metadata.name = s.split '/'
        end

        def version(s)
          @metadata.version = s
        end

        def validate_required_fields
          raise ArgumentError, 'Modulefile doesn`t contain name or author' unless
            @metadata.name and @metadata.author

          raise ArgumentError, 'Modulefile doesn`t contain version information' unless
            @metadata.version
        end
      end
    end
  end
end
