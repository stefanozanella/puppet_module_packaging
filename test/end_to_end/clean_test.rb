require 'test_helper'

describe 'clean task' do
  around do |t|
    do_into_tmp_module('testmod', t)
  end

  it 'removes the directories produced by the install task' do
    `rake install`
    `rake clean`

    refute directory?('build'), 'expected build dir to have been wiped, but it was still there'
  end
end
