require 'test_helper'

describe PuppetModule::Pkg::Tasks::Install do
  let(:install_task) { PuppetModule::Pkg::Tasks::Install }
  let(:sys)          { stub_everything }
  let(:mod)          { OpenStruct.new(:name => 'my_mod')}
  let(:opts)         { OpenStruct.new(:install_dir => 'build')}
  let(:dest_path)    { "usr/share/puppet/modules/#{mod.name}" }
  let(:install_path) { join(opts.install_dir, dest_path) }

  it 'creates the output folder' do
    sys.expects(:mkdir).with(regexp_matches(/#{opts.install_dir}/))

    install_task.new(sys).invoke(mod, opts)
  end

  it 'creates the destination path into the output folder' do
    sys.expects(:mkdir).with(regexp_matches(/#{dest_path}/))

    install_task.new(sys).invoke(mod, opts)
  end

  it 'installs all the relevant directories into the output folder' do
    sys.expects(:cp).with(
      includes(
        'Modulefile',
        'manifests',
        'templates',
        'files',
        'lib'),
      install_path)

    install_task.new(sys).invoke(mod, opts)
  end
end
