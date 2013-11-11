require 'puppet_module/pkg/tasks/build'

module PuppetModule
  module Pkg
    class Tasks
      class RPM < Build
        type :rpm

        filename '#{pkg_name}-VERSION.ARCH.rpm'
      end
    end
  end
end
