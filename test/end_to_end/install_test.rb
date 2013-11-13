require 'test_helper'

describe 'install task' do
  describe 'by default' do
    around do |t|
      do_into_tmp_module('testmod', t)
    end

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

  # Issue #1
  describe 'when not all standard module directories are present' do
    around do |t|
      do_into_tmp_module('testmod_small', t)
    end

    let(:output_dir) { 'build/usr/share/puppet/modules/testmod_small' }

    it 'installs the module anyway' do
      `rake install`

      assert directory?(output_dir), "expected #{output_dir} to exist, but it didn't"
      filesystem {
        dir 'manifests' do
          file 'init.pp'
        end

        dir 'templates' do
          file 'config.erb'
        end
      }.must_exist_within output_dir
    end
  end
end
