require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/filesystem'
require 'minitest/around/spec'
require 'mocha/setup'

require 'tmpdir'

require 'puppet_module/pkg/tasks'

def fixture_dir
  File.join File.dirname(__FILE__), 'fixture'
end

def fixture_module(name)
  File.join(fixture_dir, name)
end

def walk_path(dirs)
  (1..dirs.to_a.length).map do |k|
    File.join(*dirs.to_a.take(k))
  end
end

def do_into_dir(dir, t)
  Dir.chdir dir do
    t.call
  end
end

def do_into_tmpdir(t)
  Dir.mktmpdir do |dir|
    do_into_dir(dir, t)
  end
end

def do_into_tmp_module(mod_name, t)
  do_into_tmpdir(proc {
    FileUtils.cp_r fixture_module(mod_name), mod_name
    do_into_dir(mod_name, t)
  })
end

def directory?(d)
  File.directory? d
end

def file?(f)
  File.file? f
end

def mkdir(d)
  FileUtils.mkdir d
end

def touch(f)
  FileUtils.touch f
end

def join(*args)
  File.join(*args)
end
