require 'test_helper'

describe 'deb task' do
  around do |t|
    do_into_tmp_module('testmod', t)
  end

  describe 'by default' do
    let(:pkg) { 'pkg/puppet-mod-testdev-testmod_0.0.1_all.deb' }

    it 'build a package into the `pkg` folder' do
      `rake deb`

      assert file?(pkg), "expected package #{pkg} to exist"
    end
  end
end
