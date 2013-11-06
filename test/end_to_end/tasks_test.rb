require 'test_helper'

describe 'using PuppetModule::Pkg::Tasks in a Rakefile' do
  around do |t|
    do_into_tmp_module('testmod', t)
  end

  let(:fixture_module) { File.join(fixture_dir, 'testmod') }

  it 'defines a `install` task' do
    task_list = `rake -T`
    task_list.must_match /^rake install/
  end
end
