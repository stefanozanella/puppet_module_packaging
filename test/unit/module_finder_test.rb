require 'test_helper'

describe PuppetModule::Pkg::Tasks::ModuleFinder do
  let(:sys)           { mock }
  let(:parser_class)  { stub_everything }
  let(:mod_finder)    { PuppetModule::Pkg::Tasks::ModuleFinder.new sys, parser_class }

  describe '#find_in' do
    it 'parses the modulefile for each module found in the given directory' do
      sys.expects(:ls).with('root/folder').returns(['mod_1', 'mod_2'])
      parser_class.expects(:parse)\
        .with('root/folder/mod_1/Modulefile')\
        .with('root/folder/mod_2/Modulefile')\

      mod_finder.find_in('root/folder')
    end

    it 'returns a list of parsed modulefiles' do
      sys.stubs(:ls).with('root/folder').returns(['mod_3', 'mod_4'])
      parser_class.stubs(:parse).returns(OpenStruct.new)

      modules = mod_finder.find_in('root/folder')
      modules.length.must_equal 2 
      modules.first.must_be_kind_of OpenStruct
    end
  end

  describe PuppetModule::Pkg::Tasks::ModuleFinder::Disabled do
    let(:mod_finder) { PuppetModule::Pkg::Tasks::ModuleFinder::Disabled.new nil, nil}

    describe '#find_in' do
      it 'returns an empty list of dependencies, no matter the arguments' do
        mod_finder.find_in('one/two/three').must_equal []
      end
    end
  end
end
