class puppet::privatemaster {
  include repos::epel
  repos::use_repo { epel : }
  user { puppet: }
  
  package { mercurial:
    ensure => installed,
    require => Yumrepo["epel"];
  }
  
  package { "puppet-server":
    ensure => installed,
    require => [Yumrepo["epel"]];
  }
  
  file { '/etc/sysconfig/puppetmaster':
    source =>  'puppet:///modules/puppet/etc/sysconfig/puppetmaster',
    alias => puppetmaster_sysconfig;
  }
  
  file { ['/var/run/puppet.private', '/etc/puppet/private','/var/lib/puppet.private']:
    ensure => directory,
    owner => "puppet";
  }
  
  file { '/usr/sbin/puppet-ext-nodes-from-file':
    source => 'puppet:///modules/puppet/usr/sbin/puppet-ext-nodes-from-file',
    owner => "puppet",
    ensure => file,
    mode => 755;
  }
  
  file { '/etc/puppet/private/puppet.conf' :
    alias => puppetmaster_config,
    source =>  'puppet:///modules/puppet/etc/puppet/private.puppet.conf';
    
  }
  
  file { '/etc/puppet/private/fileserver.conf' :
    alias => puppetmaster_fileserver_config,
    source =>  'puppet:///modules/puppet/etc/puppet/fileserver.conf';
  }
  
  service { puppetmaster:
    ensure => running,
    subscribe => [File['puppetmaster_sysconfig'],File['puppetmaster_fileserver_config'],File['puppetmaster_config']],
    require => Package['puppet-server'];
  }
  
}