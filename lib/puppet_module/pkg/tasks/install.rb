module PuppetModule
  module Pkg
    class Tasks
      class Install
        def initialize(filesystem)
          @fs = filesystem
        end

        def invoke(mod_name, out_dir)
          @mod_name = mod_name
          @out_dir = out_dir

          @fs.mkdir install_path
          @fs.cp assets_to_install, install_path
        end

        private

        def install_path
          File.join(@out_dir, dest_path, @mod_name)
        end

        def dest_path
          '/usr/share/puppet/modules'
        end

        def assets_to_install
          ['manifests','templates','lib','files']
        end
      end
    end
  end
end
