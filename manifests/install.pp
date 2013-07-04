# == Class elasticsearch::intall
#
class elasticsearch::install {
  include elasticsearch::params

  package { $elasticsearch::params::package_name:
    ensure => present,
  }
}
