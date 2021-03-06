class etherpad_lite::nginx (
  $default_server = 'default_server',
  $server_name    = 'localhost'
) {

  package { 'nginx':
    ensure => present
  }

  file { '/etc/nginx/sites-enabled/default':
    ensure  => absent,
    require => Package['nginx'],
    notify  => Service['nginx']
  }

  file { '/etc/nginx/sites-enabled/etherpad-lite':
    ensure  => present,
    content => template('etherpad_lite/nginx.erb'),
    replace => 'true',
    owner   => 'root',
    require => File['/etc/nginx/ssl/eplite.crt', '/etc/nginx/ssl/eplite.key'],
    notify  => Service['nginx']
  }

  file { '/etc/nginx/ssl':
    ensure => directory,
    owner  => 'root',
    mode   => 0700,
  }

  file { '/etc/nginx/ssl/eplite.crt':
    ensure  => present,
    replace => true,
    owner   => 'root',
    mode    => 0600,
    source  => 'file:///root/secret-files/eplite.crt',
    require => Package['nginx'],
  }

  file { '/etc/nginx/ssl/eplite.key':
    ensure  => present,
    replace => true,
    owner   => 'root',
    mode    => 0600,
    source  => 'file:///root/secret-files/eplite.key',
    require => Package['nginx'],
  }

  service { 'nginx':
    enable     => true,
    ensure     => running,
    hasrestart => true
  }

}
