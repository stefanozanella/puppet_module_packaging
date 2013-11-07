module PuppetModule
  module Pkg
    class Tasks
      class Clean
        def initialize(filesystem)
          @fs = filesystem
        end

        def invoke(out_dir)
          @fs.rm out_dir
        end
      end
    end
  end
end
