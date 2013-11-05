module PuppetModule
  module Pkg
    class Tasks
      class FSDriver
        def mkdir(path)
          FileUtils.mkdir_p path
        end

        def cp(src, dest)
          sanitized_src = src.is_a?(Range) ? src.to_a : src

          FileUtils.cp_r sanitized_src, dest
        end
      end
    end
  end
end
