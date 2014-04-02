require 'puppet_module/pkg/tasks/packager'

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
        def initialize(system, mod_finder)
          @sys = system
          @mod_finder = mod_finder
        end

        def invoke(mod, opts)
          self.modinfo = mod
          self.build_opts = opts

          @sys.mkdir opts.pkg_dir
          @packager = Packager.new(@sys)
          @packager.package(mod, opts.install_dir, opts.pkg_dir, type, filename)

          @mod_finder.find_in(opts.dep_install_path).each do |dep|
            @packager.package(dep, File.join(opts.dep_build_path, dep.name), opts.pkg_dir, type, filename_for(dep.name, dep.author))
          end
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

        def pkg_name(mod = modinfo.name, author = modinfo.author)
          "puppet-mod-#{author}-#{mod}"
        end
      end
    end
  end
end
