require 'puppet_module/pkg/tasks/build'

module PuppetModule
  module Pkg
    class Tasks
      class Deb < Build
        type :deb

        filename '#{pkg_name}_VERSION_ARCH.deb'
      end
    end
  end
end
