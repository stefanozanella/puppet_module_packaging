require 'test_helper'

describe PuppetModule::Pkg::Tasks::Clean do
  let(:out_dir)    { 'clean_test' }
  let(:clean_task) { PuppetModule::Pkg::Tasks::Clean }
  let(:fs)         { stub_everything }

  it 'removes the installation directory' do
    fs.expects(:rm).with(regexp_matches(/#{out_dir}/))

    clean_task.new(fs).invoke(out_dir)
  end
end
