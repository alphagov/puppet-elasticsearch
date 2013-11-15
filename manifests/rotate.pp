# == Type: elasticsearch::rotate
#
# Rotate elasticsearch indexes
#
# === Parameters
#
# [*hour*]
#   The hour of the day to run the command.
#   Default: '0'
#
# [*minute*]
#   The minute of the day to run the command.
#   Default: '1'
#
# [*delete_old*]
#   Whether or not to delete the old indexes.
#   Default: 'yes'
#
# [*delete_maxage*]
#   The maximum age (in days) of index to keep.
#   Default: '21'
#
# [*prefix*]
#   The prefix string of indexes to rotate.
#   Default: 'logs'
#
define elasticsearch::rotate (
  $ensure = 'present',
  $user = 'nobody',
  $hour = '0',
  $minute = '1',
  $delete_old = 'yes',
  $delete_maxage = '21',
  $prefix = 'logs'
) {
  case $ensure {
    'present': {
      $command = '/usr/local/bin/es-rotate'
      if str2bool($delete_old) {
        $command1 = "${command} --delete-old --delete-maxage ${delete_maxage}"
      } else {
        $command1 = $command
      }
      $command2 = "${command1} --optimize-old --optimize-maxage 1 ${prefix}"
      cron { "${title}-cron":
        ensure  => present,
        user    => $user,
        hour    => $hour,
        minute  => $minute,
        command => $command2,
        require => Class['elasticsearch::service'],
      }
    }

    'absent': {
      cron { "${title}-cron":
        ensure => absent,
      }
    }

    default: {
      fail("Invalid 'ensure' value '${ensure}' for elasticsearch::rotate")
    }

  }
}
