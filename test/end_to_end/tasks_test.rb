require 'test_helper'

describe 'using PuppetModule::Pkg::Tasks in a Rakefile' do
  let(:fixture_module) { File.join(fixture_dir, 'testmod') }
  let(:fixture_rakefile) { File.join(fixture_module, 'Rakefile') }
  it 'defines a `install` task' do
    task_list = `rake -f #{fixture_rakefile} -T`
    task_list.must_match /^rake install/
  end
end
