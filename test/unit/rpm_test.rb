require 'test_helper'

describe PuppetModule::Pkg::Tasks::RPM do
  let(:rpm_task)    { PuppetModule::Pkg::Tasks::RPM }
  let(:sys)         { stub_everything }
  let(:mod) { OpenStruct.new(
    :name    => 'my_mod',
    :author  => 'a_dev',
    :version => 'some_version')
  }
  let(:opts) { OpenStruct.new(
    :pkg_dir     => 'pkg',
    :install_dir => 'some/where')
  }

  it 'creates the output folder' do
    sys.expects(:mkdir).with(regexp_matches(/#{opts.pkg_dir}/))

    rpm_task.new(sys).invoke(mod, opts)
  end

  it 'builds a rpm package using mandatory module info' do
    sys.expects(:sh).with(all_of(
      regexp_matches(/^fpm/),
      regexp_matches(/-s dir/),
      regexp_matches(/-t rpm/),
      regexp_matches(/-a all/),
      regexp_matches(/-n puppet-mod-#{mod.author}-#{mod.name}/),
      regexp_matches(/-p #{opts.pkg_dir}\/puppet-mod-#{mod.author}-#{mod.name}-VERSION.ARCH.rpm/),
      regexp_matches(/-v #{mod.version}/),
      regexp_matches(/-C #{opts.install_dir}/),
      regexp_matches(/\.$/)))

    rpm_task.new(sys).invoke(mod, opts)
  end
end
