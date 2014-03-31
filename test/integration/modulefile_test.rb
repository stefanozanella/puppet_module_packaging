require 'test_helper'

describe PuppetModule::Pkg::Tasks::Modulefile do
  # TODO: dependency management
  #
  # TODO: Modulefile not present => Errno::ENOENT, Errno::EISDIR => requires
  # specification of shell output format
  #
  # TODO: incorrect format (maybe)
  #
  # TODO: allow for single-dash commented line to be parsed (maybe,
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
    metadata.source.must_equal 'https://example.com/git/testmod'
    metadata.author_full.must_equal 'Test Developer <test@example.com>'
    metadata.license.must_equal 'Apache License, Version 2.0'
    metadata.summary.must_equal 'A silly module, only useful for testing'
    metadata.description.must_equal 'A long description of this silly module'
    metadata.project_page.must_equal 'https://example.com/testmod/home'
    metadata.dependencies.must_equal [
      { :author => 'user_1', :name => 'mod_1', :versions => ['= 1.2.3'] },
      { :author => 'user_2', :name => 'mod_2', :versions => ['>= 1.0.0', '< 3.2']},
    ]
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

  it 'doesn`t complain if it finds an unsupported/unrecognized field' do
    metadata = parser.parse 'Modulefile'
    metadata.unsupported_field.must_be_nil
  end
end
