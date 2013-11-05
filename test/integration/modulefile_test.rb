require 'test_helper'

describe PuppetModule::Pkg::Tasks::Modulefile do
  # todo: Modulefile not present
  # todo: incorrect format
  # todo: missing required fields

  around do |t|
    do_into_dir(fixture_module('testmod'), t)
  end

  let(:parser) { PuppetModule::Pkg::Tasks::Modulefile }

  it 'reads a Modulefile and maps its fields to an object value' do
    metadata = parser.parse 'Modulefile'
    metadata.name.must_equal 'testmod'
  end
end