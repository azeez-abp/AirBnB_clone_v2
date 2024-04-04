#configure server
exec { 'update-upgrade':
  command => 'apt-get -y update && apt-get -y upgrade',
}

package { 'nginx':
  ensure => installed,
}

file { ['/data/web_static/releases/test', '/data/web_static/shared']:
  ensure => directory,
}

file { '/data/web_static/releases/test/index.html':
  ensure  => file,
  content => 'This is a test\n',
}

file { '/data/web_static/current':
  ensure => link,
  target => '/data/web_static/releases/test/',
  force  => true,
}

file_line { 'add-nginx-location':
  path  => '/etc/nginx/sites-available/default',
  line  => 'location /hbnb_static/ {',
  match => '^(\s*)location / {',
}

service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx'],
  notify  => File['/etc/nginx/sites-available/default'],
}

