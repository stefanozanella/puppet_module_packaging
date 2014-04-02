module PuppetModule
  module Pkg
    class Tasks
      class ModuleFinder
        def initialize(system, parser = Modulefile)
          @sys = system
          @parser = parser
        end

        def find_in(path)
          @sys.ls(path).map do |mod|
            @parser.parse(File.join(path, mod, "Modulefile"))
          end
        end

        class Disabled < ModuleFinder
          def find_in(path)
            []
          end
        end
      end
    end
  end
end
