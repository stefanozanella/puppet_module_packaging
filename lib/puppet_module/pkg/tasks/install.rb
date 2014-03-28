module PuppetModule
  module Pkg
    class Tasks
      class Install
        def initialize(system)
          @sys = system
        end

        def invoke(mod, opts)
          @mod_name = mod.name
          @out_dir = opts.install_dir

          @sys.mkdir install_path
          @sys.cp assets_to_install, install_path
        end

        private

        def install_path
          File.join(@out_dir, dest_path, @mod_name)
        end

        def dest_path
          '/usr/share/puppet/modules'
        end

        def assets_to_install
          ['Modulefile','manifests','templates','lib','files']
        end
      end
    end
  end
end
