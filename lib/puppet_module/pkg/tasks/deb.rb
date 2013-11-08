module PuppetModule
  module Pkg
    class Tasks
      class Deb
        def initialize(system)
          @sys = system
        end

        def invoke(mod, opts)
          @mod = mod
          @opts = opts

          @sys.mkdir opts.pkg_dir
          @sys.sh("fpm #{fpm_opts} #{install_files}")
        end

        private

        def fpm_opts
          [ src_fmt, dest_fmt, name, version, arch, chdir, output ].join " "
        end

        def pkg_name
          "puppet-mod-#{@mod.author}-#{@mod.name}"
        end

        def name
          "-n #{pkg_name}"
        end

        def version
          "-v #{@mod.version}"
        end

        def arch
          "-a all"
        end

        def src_fmt
          "-s dir"
        end

        def dest_fmt
          "-t deb"
        end

        def chdir
          "-C #{@opts.install_dir}"
        end

        def output
          "-p #{@opts.pkg_dir}/#{pkg_name}_VERSION_ARCH.deb"
        end

        def install_files
          "."
        end
      end
    end
  end
end
