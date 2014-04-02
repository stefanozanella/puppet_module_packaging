module PuppetModule
  module Pkg
    class Tasks
      class System
        def mkdir(path)
          FileUtils.mkdir_p path
        end

        def cp(src, dest)
          FileUtils.cp_r only_existing_entries_of(ensure_array(src)), dest
        end

        def rm(path)
          FileUtils.rm_rf path
        end

        def sh(cmd)
          # TODO: This should be supported through an external logger!
          puts `#{cmd}`
        end

        def ls(path)
          Dir.new(path).entries.reject { |d| d =~ /^\.*$/ }
        end

        private

        def ensure_array(src)
          src.is_a?(Range) ? src.to_a : src
        end

        def only_existing_entries_of(src)
          src.select { |f| File.exists? f }
        end
      end
    end
  end
end
