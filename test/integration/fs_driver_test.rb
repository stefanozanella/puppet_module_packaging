require 'test_helper'
require 'tmpdir'

describe PuppetModule::Pkg::Tasks::FSDriver do
  let(:fs) { PuppetModule::Pkg::Tasks::FSDriver.new }

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
  end

  describe 'rm' do
    it 'removes the whole subtree under given directory' do
      mkdir 'a/b/c/d'

      fs.rm 'a'
      refute directory?('a'), "expected directory 'a' to have been wiped"
    end
  end
end
