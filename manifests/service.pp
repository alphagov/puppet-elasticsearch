# == Class elasticsearch::service
#
# This class is meant to be called from elasticsearch
# It ensure the service is running
#
class elasticsearch::service {
  include elasticsearch::params

  service { $elasticsearch::params::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
