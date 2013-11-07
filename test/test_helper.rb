require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/filesystem'
require 'minitest/around/spec'
require 'mocha/setup'

require 'tmpdir'

require 'puppet_module/pkg/tasks'

# Directory that contains test fixtures
def fixture_dir
  File.join File.dirname(__FILE__), 'fixture'
end

# Path of the test module named `name`
def fixture_module(name)
  File.join(fixture_dir, name)
end

# Creates an array of all increasing paths from dirs.first to dirs.last
#
# Ex: walk_path(['a','b','c']) # => ['a', 'a/b', 'a/b/c']
def walk_path(dirs)
  (1..dirs.to_a.length).map do |k|
    File.join(*dirs.to_a.take(k))
  end
end

# Exec proc inside specified directory
def do_into_dir(dir, t)
  Dir.chdir dir do
    t.call
  end
end

# Exec proc inside a temp dir
def do_into_tmpdir(t)
  Dir.mktmpdir do |dir|
    do_into_dir(dir, t)
  end
end

# Exec proc inside a temp copy of fixture module `mod_name`
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
  FileUtils.mkdir_p d
end

def touch(f)
  FileUtils.touch f
end

def join(*args)
  File.join(*args)
end
