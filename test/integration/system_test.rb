require 'test_helper'
require 'tmpdir'

describe PuppetModule::Pkg::Tasks::System do
  let(:fs) { PuppetModule::Pkg::Tasks::System.new }

  around do |t|
    do_into_tmpdir(t)
  end

  describe 'mkdir' do
    it 'creates a whole directory subtree' do
      fs.mkdir('a/b/c/d')

      walk_path('a'..'d').each do |dir|
        assert directory?(dir), "expected directory #{dir} to exist"
      end
    end

    it 'doesn`t complain if some of the directories already exist' do
      fs.mkdir('a/b/c/d')
      fs.mkdir('a/b/c/d')
    end
  end

  describe 'cp' do
    it 'recursively copies a list of directories into a destination' do
      mkdir 'out'
      ('a'..'d').to_a.each do |dir|
        mkdir dir
        touch join dir, "test_#{dir}"
      end

      fs.cp('a'..'d', 'out')

      ('a'..'d').to_a.each do |dir|
        assert directory?(join 'out', dir), "expected directory #{dir} to exist"
        assert file?(join 'out', dir, "test_#{dir}"), "expected file out/#{dir}/test_#{dir} to exist"
      end
    end

    it 'doesn`t complain if some directories are not found' do
      mkdir 'directory'
      mkdir 'out'

      fs.cp(['directory', 'not', 'found'], 'out')

      refute exists?(join 'out', 'not')
      refute exists?(join 'out', 'found')
    end
  end

  describe 'rm' do
    it 'removes the whole subtree under given directory' do
      mkdir 'a/b/c/d'

      fs.rm 'a'
      refute directory?('a'), "expected directory 'a' to have been wiped"
    end
  end

  describe 'sh' do
    it 'executes given command in system`s shell' do
      fs.sh 'touch test_file'

      assert file?('test_file'), "expected file test_file to have been created, but it was not"
    end
  end

  describe 'ls' do
    it 'returns an array with the entries of a specific folder' do
      mkdir 'a_dir/a'
      mkdir 'a_dir/b'
      mkdir 'a_dir/c'
      mkdir 'a_dir/c/d'

      listing = fs.ls 'a_dir'

      listing.length.must_equal 3
      listing.must_include 'a'
      listing.must_include 'b'
      listing.must_include 'c'
    end
  end
end
