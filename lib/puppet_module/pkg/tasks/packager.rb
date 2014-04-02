module PuppetModule
  module Pkg
    class Tasks
      class Packager
        def initialize(system)
          @sys = system
        end

        def package(mod, install_dir, pkg_dir, type, filename)
          self.modinfo = mod
          @install_dir = install_dir
          @pkg_dir = pkg_dir

          @type = type
          @filename = filename
          @sys.sh("fpm #{fpm_opts} #{installed_files}")
        end

        private

        attr_accessor :modinfo

        def fpm_opts
          [ src_fmt,
            dest_fmt,
            name,
            version,
            arch,
            maintainer,
            url,
            description,
            license,
            dependencies,
            chdir,
            output ].join " "
        end

        def pkg_name
          "puppet-mod-#{modinfo.author}-#{modinfo.name}"
        end

        def name
          "-n #{pkg_name}"
        end

        def version
          "-v #{modinfo.version}"
        end

        def arch
          "-a all"
        end

        def maintainer
          optionally('-m', modinfo.author_full)
        end

        def url
          optionally('--url', modinfo.project_page)
        end

        def description
          optionally('--description', modinfo.summary)
        end

        def license
          optionally('--license', modinfo.license)
        end

        def dependencies
          return "" unless modinfo.dependencies

          modinfo.dependencies.map do |dep|
            dep[:versions].map do |version_constraint|
              "-d 'puppet-mod-#{dep[:author]}-#{dep[:name]} #{version_constraint}'"
            end
          end
        end

        def src_fmt
          "-s dir"
        end

        def chdir
          "-C #{@install_dir}"
        end

        def installed_files
          "."
        end

        def output
          "-p #{@pkg_dir}/#{@filename}"
        end

        def dest_fmt
          "-t #{@type}"
        end

        def optionally(switch, field)
          field ? "#{switch} '#{field}'" : ""
        end
      end
    end
  end
end

