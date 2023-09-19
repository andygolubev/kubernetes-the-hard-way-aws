exec { 'update_package_lists':
  command => '/usr/bin/sudo /usr/bin/apt update -y',
  refreshonly => true,
}

exec { 'download etcd':
  command => 'wget -q --show-progress --https-only --timestamping \
 "https://github.com/etcd-io/etcd/releases/download/v3.4.27/etcd-v3.4.27-linux-amd64.tar.gz',
  refreshonly => true,
  cwd => /tmp
}

exec { 'unzip etcd':
  command => 'tar -xvf etcd-v3.3.5-linux-amd64.tar.gz',
  refreshonly => true,
  cwd => /tmp
}

exec { 'install etcd':
  command => '/usr/bin/sudo mv etcd-v3.4.27-linux-amd64/etcd* /usr/local/bin/',
  refreshonly => true,
  cwd => /tmp
}


package { 'nginx':
  ensure => installed,
}

file { '/home/ubuntu/file.txt':
  ensure  => present,
  content => "Hello, this is the content of the file!\n",
}

