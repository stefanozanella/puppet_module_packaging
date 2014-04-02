require 'test_helper'

describe 'deb task' do
  around do |t|
    do_into_tmp_module('testmod', t)
  end

  let(:pkg) { 'pkg/puppet-mod-testdev-testmod_0.0.1_all.deb' }

  describe 'by default' do
    it 'build a package into the `pkg` folder' do
      `rake deb`

      assert file?(pkg), "expected package #{pkg} to exist"
    end
  end

  describe 'when asked to build packages for dependencies as well' do
    let(:dep_pkgs) {[
      'pkg/puppet-mod-puppetlabs-apache_*_all.deb',
      'pkg/puppet-mod-puppetlabs-stdlib_*_all.deb',
      'pkg/puppet-mod-puppetlabs-concat_*_all.deb',
    ]}

    it 'recursively builds packages for each dependency' do
      `rake -f Rakefile.recursive deb`

      dep_pkgs.each do |dep_pkg|
        refute Dir.glob(dep_pkg).empty?, "expected package #{dep_pkg} to exist"
      end
    end
  end
end

describe 'rpm task' do
  around do |t|
    do_into_tmp_module('testmod', only_if_rpmbuild_found(t))
  end

  describe 'by default' do
    let(:pkg) { 'pkg/puppet-mod-testdev-testmod-0.0.1.noarch.rpm' }

    it 'build a package into the `pkg` folder' do
      `rake rpm`

      assert file?(pkg), "expected package #{pkg} to exist"
    end
  end
end
