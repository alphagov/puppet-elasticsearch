# elasticsearch

**THIS MODULE IS DEPRECATED**.  Please use
  [elasticsearch/elasticsearch](http://forge.puppetlabs.com/elasticsearch/elasticsearch)
  instead.

## Migrating to elasticsearch/elasticsearch

We recommend against further usage of this module, and instead suggest
you use
[elasticsearch/elasticsearch](http://forge.puppetlabs.com/elasticsearch/elasticsearch).
@gds-operations will not be maintaining this module any further.  We
have written a small guide on how to migrate from the existing module
to the elasticsearch/elasticsearch module:

### Reinstating the init.d script

This module managed the elasticsearch service using upstart, and so
removed the init.d script that the package provided to prevent
confusion.  The elasticsearch/elasticsearch manages the service using
the init.d script, so you will need to recreate it.  To recover it by
reinstalling the elasticsearch package, you can use something like
this:

    exec {'reinstate elasticsearch init script removed by gdsoperations/elasticsearch':
      command => '/usr/bin/apt-get -o Dpkg::Options::="--force-confmiss" install --reinstall elasticsearch',
      creates => '/etc/init.d/elasticsearch',
      before  => Class['::elasticsearch'],
    }

The `--force-confmiss` option is required because
`/etc/init.d/elasticsearch` is considered to be a configuration file
and so won't be recreated on reinstall by default.

### Migrating the class include itself

If currently have this usage:

    class {'::elasticsearch': # from gdsoperations/elasticsearch
      host                 => $::fqdn,
      cluster_hosts        => $cluster_hosts,
      minimum_master_nodes => (size($cluster_hosts)/2) + 1,
    }

you can replace it with:

    class { '::elasticsearch': # from elasticsearch/elasticsearch
      config => {
        'bootstrap.mlockall'                   => false,
        'cluster.name'                         => 'localhost',
        'discovery.zen.minimum_master_nodes'   => (size($cluster_hosts)/2) + 1,
        'discovery.zen.ping.multicast.enabled' => false,
        'discovery.zen.ping.unicast.hosts'     => $cluster_hosts,
        'http.port'                            => 9200,
        'index.number_of_replicas'             => 1,
        'index.number_of_shards'               => 5,
        'index.refresh_interval'               => '1s',
        'transport.tcp.port'                   => 9300,
        'network.publish_host'                 => $::fqdn,
        'node.name'                            => $::fqdn,
      },
    }

This is the simplest possible configuration that works; it takes the
old config from the template and translates it into puppet hash form.
You'll probably want to extract it into a variable or parameter
somewhere, but this will get you through the migration.

**Note** if you were using the `$data_directory` parameter, use the
  `path.data` elasticsearch configuration option.

### Migrating plugins

If you currently have:

    elasticsearch::plugin { 'head':
      install_from => 'mobz/elasticsearch-head',
    }

you can replace it with:

    elasticsearch::plugin { 'mobz/elasticsearch-head':
      module_dir => 'head',
    }

### Migrating templates

TODO.

## License

See [LICENSE](LICENSE) file.
