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
          @metadata.dependencies = []
          binding.eval str
          validate_required_fields
        end

        def method_missing(*args)
          # TODO: Maybe display an info message about the
          # unrecognized/unsupported field? (it might be a typo, so the user
          # might be happy to know what have been ignored)
        end

        private

        def name(s)
          @metadata.author, @metadata.name = s.split '-'
        end

        def version(s)
          @metadata.version = s
        end

        def source(s)
          @metadata.source = s
        end

        def author(s)
          @metadata.author_full = s
        end

        def license(s)
          @metadata.license = s
        end

        def summary(s)
          @metadata.summary = s
        end

        def description(s)
          @metadata.description = s
        end

        def project_page(s)
          @metadata.project_page = s
        end

        def dependency(mod, ver)
          a, n = mod.split('/')
          @metadata.dependencies << {
            :name => n,
            :author => a,
            :versions => dependency_versions_for(ver),
          }
        end

        def dependency_versions_for(versions_str)
          versions = []
          versions_str.split(/(>=|<=|==|=|<|>)\s+/)\
            .select { |s| !s.empty? }\
            .each_slice(2) { |v|
              versions << v.map { |s| s.strip }.join(" ")
            }

          versions
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
