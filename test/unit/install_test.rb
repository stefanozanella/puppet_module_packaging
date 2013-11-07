require 'test_helper'

describe PuppetModule::Pkg::Tasks::Install do
  let(:install_task) { PuppetModule::Pkg::Tasks::Install }
  let(:mod_name)     { 'my_module' }
  let(:fs)           { stub_everything }
  let(:out_dir)      { 'build' }
  let(:dest_path)    { "usr/share/puppet/modules/#{mod_name}" }
  let(:install_path) { join(out_dir, dest_path) }

  it 'creates the output folder' do
    fs.expects(:mkdir).with(regexp_matches(/#{out_dir}/))

    install_task.new(fs).invoke(mod_name, out_dir)
  end

  it 'creates the destination path into the output folder' do
    fs.expects(:mkdir).with(regexp_matches(/#{dest_path}/))

    install_task.new(fs).invoke(mod_name, out_dir)
  end

  it 'installs all the relevant directories into the output folder' do
    fs.expects(:cp).with(
      includes(
        'manifests',
        'templates',
        'files',
        'lib'),
      install_path)

    install_task.new(fs).invoke(mod_name, out_dir)
  end
end
