require 'test_helper'

describe 'using PuppetModule::Pkg::Tasks in a Rakefile' do
  around do |t|
    do_into_tmp_module('testmod', t)
  end

  let(:fixture_module) { File.join(fixture_dir, 'testmod') }
  let(:task_list) { `rake -T` }

  [:install, :clean].each do |task|
    it "defines a `#{task}` task" do
      task_list.must_match /^rake #{task}/
    end
  end
end
