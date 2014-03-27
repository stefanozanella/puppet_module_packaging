$deps = [
  'ruby-dev',
  'libxml2',
  'libxml2-dev',
  'libxslt1.1',
  'libxslt1-dev',
  'rpm',
  'git',
]

package { $deps:
  ensure  => installed,
  require => Exec['apt-get update'],
}

package { 'bundler':
  ensure   => installed,
  require  => Package[$deps],
  provider => 'gem',
}

exec { 'apt-get update':
  path => '/usr/bin',
}
