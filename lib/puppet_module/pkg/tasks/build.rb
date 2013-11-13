class Class
  def type(sym)
    self.class_eval <<-EOS
      def type
        "#{sym.to_s}"
      end
    EOS
  end

  def filename(str)
    self.class_eval <<-EOS
      def filename
        "#{str}"
      end
    EOS
  end
end

module PuppetModule
  module Pkg
    class Tasks
      class Build
        def initialize(system)
          @sys = system
        end

        def invoke(mod, opts)
          self.modinfo = mod
          self.build_opts = opts

          @sys.mkdir opts.pkg_dir
          @sys.sh("fpm #{fpm_opts} #{installed_files}")
        end

        def type
          raise NotImplementedError
        end

        def filename
          raise NotImplementedError
        end

        private

        attr_accessor :modinfo
        attr_accessor :build_opts

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
          "-m '#{modinfo.author_full}'"
        end

        def url
          "--url '#{modinfo.project_page}'"
        end

        def description
          "--description '#{modinfo.summary}'"
        end

        def license
          "--license '#{modinfo.license}'"
        end

        def src_fmt
          "-s dir"
        end

        def chdir
          "-C #{build_opts.install_dir}"
        end

        def installed_files
          "."
        end

        def output
          "-p #{build_opts.pkg_dir}/#{filename}"
        end

        def dest_fmt
          "-t #{type}"
        end

      end
    end
  end
end
