require 'test_helper'

describe PuppetModule::Pkg::Tasks::Modulefile do
  # todo: Modulefile not present => Errno::ENOENT, Errno::EISDIR => requires
  # specification of shell output format
  # todo: incorrect format
  # todo: unrecognized field
  # todo: allow for single-dash commented line to be parsed (maybe,
  # particularly for non-forge dependencies)

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

  it 'raises an error if the Modulefile doesn`t contain required fields' do
    # We need at least module name, developer name and version in order to
    # build a package
    proc {
      parser.parse 'Modulefile.no_name_or_author'
    }.must_raise ArgumentError

    proc {
      parser.parse 'Modulefile.no_version'
    }.must_raise ArgumentError
  end
end
