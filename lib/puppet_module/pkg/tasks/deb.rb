require 'puppet_module/pkg/tasks/build'

module PuppetModule
  module Pkg
    class Tasks
      class Deb < Build
        type :deb

        filename '#{pkg_name}_VERSION_ARCH.deb'

        def filename_for(mod, author)
          "#{pkg_name(mod, author)}_VERSION_ARCH.deb"
        end
      end
    end
  end
end
