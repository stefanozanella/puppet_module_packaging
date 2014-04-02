require 'test_helper'

describe PuppetModule::Pkg::Tasks::Install do
  let(:install_task) { PuppetModule::Pkg::Tasks::Install }
  let(:sys)          { stub_everything }
  let(:mod) { OpenStruct.new(
    :name    => 'my_mod',
    :dependencies => [
      { :author => 'user_1', :name => 'mod_1', :versions => ['< 1'] },
      { :author => 'user_2', :name => 'mod_2', :versions => ['> 2.0', '<= 3.0'] },
    ])
  }
  let(:opts) { OpenStruct.new(
    :install_dir => 'build',
    :recursive => false
  )}
  let(:dest_path)    { "usr/share/puppet/modules/#{mod.name}" }
  let(:install_path) { join(opts.install_dir, dest_path) }

  before do
    sys.stubs(:ls).returns(['mod_1', 'mod_2'])
  end

  it 'creates the output folder' do
    sys.expects(:mkdir).with(regexp_matches(/#{opts.install_dir}/))

    install_task.new(sys).invoke(mod, opts)
  end

  it 'creates the destination path into the output folder' do
    sys.expects(:mkdir).with(regexp_matches(/#{dest_path}/))

    install_task.new(sys).invoke(mod, opts)
  end

  it 'installs all the relevant assets into the output folder' do
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

  it 'doesn`t install dependencies by default' do
    sys.expects(:sh).at_most_once.with(Not(regexp_matches(/puppet module install/)))

    install_task.new(sys).invoke(mod, opts)
  end

  describe 'when managing dependencies recursively' do
    let(:opts) { OpenStruct.new(
      :install_dir => 'build',
      :recursive => true
    )}

    it 'asks puppet to install all the dependencies into a temp folder' do
      sys.expects(:sh)\
      .with(
        regexp_matches(/puppet module install -i tmp\/deps_inst -v '< 1' user_1\/mod_1/))\
      .with(
        regexp_matches(/puppet module install -i tmp\/deps_inst -v '> 2.0 <= 3.0' user_2\/mod_2/))

      install_task.new(sys).invoke(mod, opts)
    end

    it 'creates the build folder for each installed dependency' do
      sys.expects(:ls).with('tmp/deps_inst').returns(['mod_1','mod_2','mod_3'])
      sys.expects(:mkdir)\
        .with(regexp_matches(%r{tmp/deps_build/mod_1/usr/share/puppet/modules/mod_1}))
        .with(regexp_matches(%r{tmp/deps_build/mod_2/usr/share/puppet/modules/mod_2}))
        .with(regexp_matches(%r{tmp/deps_build/mod_3/usr/share/puppet/modules/mod_3}))

      install_task.new(sys).invoke(mod, opts)
    end

    it 'installs the relevant assets for each dependency into a separate directory' do
      sys.expects(:cp)\
      .with(
        includes(
          'tmp/deps_inst/mod_1/Modulefile',
          'tmp/deps_inst/mod_1/manifests',
          'tmp/deps_inst/mod_1/templates',
          'tmp/deps_inst/mod_1/files',
          'tmp/deps_inst/mod_1/lib'),
        'tmp/deps_build/mod_1/usr/share/puppet/modules/mod_1')
      .with(
        includes(
          'tmp/deps_inst/mod_2/Modulefile',
          'tmp/deps_inst/mod_2/manifests',
          'tmp/deps_inst/mod_2/templates',
          'tmp/deps_inst/mod_2/files',
          'tmp/deps_inst/mod_2/lib'),
        'tmp/deps_build/mod_2/usr/share/puppet/modules/mod_2')

      install_task.new(sys).invoke(mod, opts)
    end
  end
end
