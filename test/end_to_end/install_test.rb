require 'test_helper'

describe 'install task' do
  around do |t|
    do_into_tmp_module('testmod', t)
  end

  describe 'by default' do
    let(:output_dir) { 'build/usr/share/puppet/modules/testmod' }

    it 'installs all module dirs into the `build` subfolder' do
      `rake install`

      assert directory?(output_dir), "expected #{output_dir} to exist, but it didn't"
      filesystem {
        dir 'manifests' do
          file 'init.pp'
        end

        dir 'files' do
          file 'example.dat'
        end

        dir 'templates' do
          file 'config.erb'
        end

        dir 'lib' do
          file 'utils.rb'
        end
      }.must_exist_within output_dir
    end
  end
end
