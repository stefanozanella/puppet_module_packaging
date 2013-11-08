require 'test_helper'

describe PuppetModule::Pkg::Tasks::Modulefile do
  # todo: Modulefile not present
  # todo: incorrect format
  # todo: missing required fields

  around do |t|
    do_into_tmp_module('testmod', t)
  end

  let(:parser) { PuppetModule::Pkg::Tasks::Modulefile }

  it 'reads a Modulefile and maps its fields to an object value' do
    metadata = parser.parse 'Modulefile'
    metadata.name.must_equal 'testmod'
    metadata.author.must_equal 'testdev'
    metadata.version.must_equal '0.0.1'
  end
end
