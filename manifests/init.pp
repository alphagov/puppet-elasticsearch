# == Class: elasticsearch
#
# Full description of class elasticsearch here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class elasticsearch (
) inherits elasticsearch::params {

  # validate parameters here

  anchor { 'elasticsearch::begin': } ->
  class { 'elasticsearch::install': } ->
  class { 'elasticsearch::config': }
  class { 'elasticsearch::service': } ->
  anchor { 'elasticsearch::end': }

  Anchor['elasticsearch::begin']  ~> Class['elasticsearch::service']
  Class['elasticsearch::install'] ~> Class['elasticsearch::service']
  Class['elasticsearch::config']  ~> Class['elasticsearch::service']
}
