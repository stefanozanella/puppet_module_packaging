module PuppetModule
  module Pkg
    class Tasks
      class Install
        def initialize(system)
          @sys = system
        end

        def invoke(mod, opts)
          @mod = mod
          @out_dir = opts.install_dir

          @sys.mkdir install_path
          @sys.cp assets_to_install, install_path

          install_deps if opts.recursive
        end

        private

        def install_path
          File.join(@out_dir, dest_path, @mod.name)
        end

        def dest_path
          '/usr/share/puppet/modules'
        end

        def assets_to_install
          ['Modulefile','manifests','templates','lib','files']
        end

        def install_deps
          # TODO: Refactor!!! Too many hardcoded paths
          @mod.dependencies.each do |dep|
            @sys.sh("puppet module install -i tmp/deps_inst -v '#{dep[:versions].join(' ')}' #{dep[:author]}/#{dep[:name]}")
          end

          @sys.ls('tmp/deps_inst').each do |dep|
            @sys.mkdir "tmp/deps_build/#{dep}#{dest_path}/#{dep}"
            @sys.cp assets_to_install.map { |a| "tmp/deps_inst/#{dep}/#{a}" },
              "tmp/deps_build/#{dep}#{dest_path}/#{dep}"
          end
        end
      end
    end
  end
end
