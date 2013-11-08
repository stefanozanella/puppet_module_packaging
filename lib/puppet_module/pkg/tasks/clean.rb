module PuppetModule
  module Pkg
    class Tasks
      class Clean
        def initialize(system)
          @sys = system
        end

        def invoke(mod, opts)
          @sys.rm opts.install_dir
        end
      end
    end
  end
end
