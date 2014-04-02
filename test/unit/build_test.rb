require 'test_helper'

describe 'packaging tasks' do
  let(:deb_task)    { PuppetModule::Pkg::Tasks::Deb }
  let(:rpm_task)    { PuppetModule::Pkg::Tasks::RPM }
  let(:sys)         { stub_everything }
  let(:mod_finder)  { stub_everything }

  let(:minimal_mod) { OpenStruct.new(
    :name    => 'my_mod',
    :author  => 'a_dev',
    :version => 'some_version')
  }

  let(:mod) { OpenStruct.new(
    :name    => 'my_mod',
    :author  => 'a_dev',
    :version => 'some_version',
    :author_full => 'a_dev <a@dev.com>',
    :project_page => 'http://a.b.c/my_mod',
    :summary => 'nothing fancy',
    :license => 'whatever',
    :dependencies => [
      { :author => 'user_1', :name => 'mod_1', :versions => ['< 1'] },
      { :author => 'user_2', :name => 'mod_2', :versions => ['> 2.0', '<= 3.0'] },
    ])
  }

  let(:opts) { OpenStruct.new(
    :pkg_dir     => 'pkg',
    :install_dir => 'some/where',
    :recursive   => false)
  }

  before do
    mod_finder.stubs(:find_in).returns([])
  end

  it 'creates the output folder' do
    sys.expects(:mkdir).with(regexp_matches(/#{opts.pkg_dir}/))

    deb_task.new(sys, mod_finder).invoke(mod, opts)
  end

  it 'builds a package using all available module info' do
    sys.expects(:sh).with(all_of(
      regexp_matches(/^fpm/),
      regexp_matches(/-s dir/),
      regexp_matches(/-a all/),
      regexp_matches(/-n puppet-mod-#{mod.author}-#{mod.name}/),
      regexp_matches(/-v #{mod.version}/),
      regexp_matches(/-m '#{mod.author_full}'/),
      regexp_matches(/-d 'puppet-mod-user_1-mod_1 < 1'/),
      regexp_matches(/-d 'puppet-mod-user_2-mod_2 > 2.0'/),
      regexp_matches(/-d 'puppet-mod-user_2-mod_2 <= 3.0'/),
      regexp_matches(/--url '#{mod.project_page}'/),
      regexp_matches(/--description '#{mod.summary}'/),
      regexp_matches(/--license '#{mod.license}'/),
      regexp_matches(/-C #{opts.install_dir}/),
      regexp_matches(/\.$/)))

    deb_task.new(sys, mod_finder).invoke(mod, opts)
  end

  it 'doesn`t complain if optional module info are missing' do
    sys.expects(:sh).with(Not(any_of(
      regexp_matches(/-m /),
      regexp_matches(/--url /),
      regexp_matches(/--description /),
      regexp_matches(/--license /)
    )))

    deb_task.new(sys, mod_finder).invoke(minimal_mod, opts)
  end

  describe 'deb task' do
    it 'builds a deb package, using Debian conventions' do
      sys.expects(:sh).with(all_of(
        regexp_matches(/-t deb/),
        regexp_matches(/-p #{opts.pkg_dir}\/puppet-mod-#{mod.author}-#{mod.name}_VERSION_ARCH.deb/)))
  
      deb_task.new(sys, mod_finder).invoke(mod, opts)
    end
  end

  describe 'rpm task' do
    it 'builds a rpm package, using RPM conventions' do
      sys.expects(:sh).with(all_of(
        regexp_matches(/-t rpm/),
        regexp_matches(/-p #{opts.pkg_dir}\/puppet-mod-#{mod.author}-#{mod.name}-VERSION.ARCH.rpm/)))
  
      rpm_task.new(sys, mod_finder).invoke(mod, opts)
    end
  end

  describe 'when recursively building packages for module`s dependencies' do
    let(:opts) { OpenStruct.new(
      :pkg_dir           => 'module_pkg',
      :install_dir       => 'some/where/else',
      :dep_build_path    => 'some/tmp/folder',
      :dep_install_path  => 'another/tmp/folder',
      :recursive         => true)
    }

    let(:depmod_1) { OpenStruct.new(
      :name    => 'mod_1',
      :author  => 'dev_1',
      :version => 'version_1',
    )}

    let(:depmod_2) { OpenStruct.new(
      :name    => 'mod_2',
      :author  => 'dev_2',
      :version => 'version_2',
    )}

    it 'builds a package for each installed dependency' do
      mod_finder.expects(:find_in).with(opts.dep_install_path)\
        .returns([ depmod_1, depmod_2 ])

      sys.expects(:sh)\
        .with(all_of(
          regexp_matches(/^fpm/),
          regexp_matches(/-n puppet-mod-#{depmod_1.author}-#{depmod_1.name}/),
          regexp_matches(/-v #{depmod_1.version}/),
          regexp_matches(/-C #{opts.dep_build_path}\/#{depmod_1.name}/),
          regexp_matches(/-p #{opts.pkg_dir}\/puppet-mod-#{depmod_1.author}-#{depmod_1.name}_VERSION_ARCH.deb/),
          regexp_matches(/\.$/)))\
        .with(all_of(
          regexp_matches(/^fpm/),
          regexp_matches(/-n puppet-mod-#{depmod_2.author}-#{depmod_2.name}/),
          regexp_matches(/-v #{depmod_2.version}/),
          regexp_matches(/-C #{opts.dep_build_path}\/#{depmod_2.name}/),
          regexp_matches(/-p #{opts.pkg_dir}\/puppet-mod-#{depmod_2.author}-#{depmod_2.name}_VERSION_ARCH.deb/),
          regexp_matches(/\.$/)))

      deb_task.new(sys, mod_finder).invoke(minimal_mod, opts)
    end
  end
end

