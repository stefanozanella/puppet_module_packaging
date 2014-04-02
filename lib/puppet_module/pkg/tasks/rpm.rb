require 'puppet_module/pkg/tasks/build'

module PuppetModule
  module Pkg
    class Tasks
      class RPM < Build
        type :rpm

        filename '#{pkg_name}-VERSION.ARCH.rpm'

        def filename_for(mod, author)
          "#{pkg_name(mod, author)}-VERSION_ARCH.rpm"
        end
      end
    end
  end
end
