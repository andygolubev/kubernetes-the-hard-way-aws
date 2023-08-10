exec { 'update_package_lists':
  command => '/usr/bin/sudo /usr/bin/apt update -y',
  refreshonly => true,
}

package { 'nginx':
  ensure => installed,
}

file { '/home/ubuntu/file.txt':
  ensure  => present,
  content => "Hello, this is the content of the file!\n",
}

