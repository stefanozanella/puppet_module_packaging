require 'test_helper'

describe PuppetModule::Pkg::Tasks::Clean do
  let(:clean_task) { PuppetModule::Pkg::Tasks::Clean }
  let(:sys)        { stub_everything }
  let(:opts)       { OpenStruct.new(:install_dir => 'clean_test')}

  it 'removes the installation directory' do
    sys.expects(:rm).with(regexp_matches(/#{opts.install_dir}/))

    clean_task.new(sys).invoke(nil, opts)
  end
end
