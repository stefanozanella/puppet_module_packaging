require 'test_helper'

describe 'packaging tasks' do
  let(:deb_task)    { PuppetModule::Pkg::Tasks::Deb }
  let(:rpm_task)    { PuppetModule::Pkg::Tasks::RPM }
  let(:sys)         { stub_everything }
  let(:mod) { OpenStruct.new(
    :name    => 'my_mod',
    :author  => 'a_dev',
    :version => 'some_version',
    :author_full => 'a_dev <a@dev.com>',
    :project_page => 'http://a.b.c/my_mod',
    :summary => 'nothing fancy',
    :license => 'whatever')
  }
  let(:opts) { OpenStruct.new(
    :pkg_dir     => 'pkg',
    :install_dir => 'some/where')
  }

  it 'creates the output folder' do
    sys.expects(:mkdir).with(regexp_matches(/#{opts.pkg_dir}/))

    deb_task.new(sys).invoke(mod, opts)
  end

  it 'builds a package using all available module info' do
    sys.expects(:sh).with(all_of(
      regexp_matches(/^fpm/),
      regexp_matches(/-s dir/),
      regexp_matches(/-a all/),
      regexp_matches(/-n puppet-mod-#{mod.author}-#{mod.name}/),
      regexp_matches(/-v #{mod.version}/),
      regexp_matches(/-m '#{mod.author_full}'/),
      regexp_matches(/--url '#{mod.project_page}'/),
      regexp_matches(/--description '#{mod.summary}'/),
      regexp_matches(/--license '#{mod.license}'/),
      regexp_matches(/-C #{opts.install_dir}/),
      regexp_matches(/\.$/)))

    deb_task.new(sys).invoke(mod, opts)
  end

  it 'doesn`t complain if optional module info are missing' do
    # use mod from a different, stripped-down modulefile
    deb_task.new(sys).invoke(mod, opts)
  end

  describe 'deb task' do
    it 'builds a deb package, using Debian conventions' do
      sys.expects(:sh).with(all_of(
        regexp_matches(/-t deb/),
        regexp_matches(/-p #{opts.pkg_dir}\/puppet-mod-#{mod.author}-#{mod.name}_VERSION_ARCH.deb/)))
  
      deb_task.new(sys).invoke(mod, opts)
    end
  end

  describe 'rpm task' do
    it 'builds a rpm package, using RPM conventions' do
      sys.expects(:sh).with(all_of(
        regexp_matches(/-t rpm/),
        regexp_matches(/-p #{opts.pkg_dir}\/puppet-mod-#{mod.author}-#{mod.name}-VERSION.ARCH.rpm/)))
  
      rpm_task.new(sys).invoke(mod, opts)
    end
  end
end

