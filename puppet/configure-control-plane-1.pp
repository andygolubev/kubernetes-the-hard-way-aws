exec { 'update package lists':
  command => '/usr/bin/sudo /usr/bin/apt update -y',
  refreshonly => true,
}

package { 'nginx':
  ensure => installed,
}


package { 'wget':
  ensure => installed,
}

exec { 'install tools':
  command => '/usr/bin/sudo /usr/bin/apt install -y wget',
  refreshonly => true,
}

exec { 'download etcd':
  command => '/usr/bin/wget -q --show-progress --https-only --timestamping \
 "https://github.com/etcd-io/etcd/releases/download/v3.4.27/etcd-v3.4.27-linux-amd64.tar.gz',
  refreshonly => true,
}

exec { 'unzip etcd':
  command => '/usr/bin/tar -xvf etcd-v3.3.5-linux-amd64.tar.gz',
  refreshonly => true,
}

exec { 'install etcd':
  command => '/usr/bin/sudo mv etcd-v3.4.27-linux-amd64/etcd* /usr/local/bin/',
  refreshonly => true,
}



file { '/home/ubuntu/file.txt':
  ensure  => present,
  content => "Hello, this is the content of the file!\n",
}

