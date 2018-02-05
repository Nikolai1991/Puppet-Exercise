exec { 'apt-update':
command => '/usr/bin/apt-get update'
}

package { 'default-jre':
require => Exec['apt-update'],
ensure => installed,
}

tomcat::install { '/opt/tomcat9':
        source_url => 'https://www.apache.org/dist/tomcat/tomcat-9/v9.0.2/bin/apache-tomcat-9.0.2.tar.gz'
}

tomcat::instance { 'default':
  catalina_home => '/opt/tomcat9',
}

class { 'apache': }
apache::mod { 'proxy': }
apache::mod { 'proxy_http': }

apache::vhost { 'puppetagent.test.org':
docroot => '/var/www/vhost',
poert => '80',

proxy_pass => {
  path => '/',
  url => 'http://127.0.0.1:8080/',
}
}
