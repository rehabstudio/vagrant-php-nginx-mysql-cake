include 'stdlib'

# global settings class
class settings {
    $ymlconfig = loadyaml('/vagrant/config.yml')
}

# globals
Exec {
    path => ['/bin', '/sbin', '/usr/bin', '/usr/local/bin', '/usr/sbin'],
    environment => "COMPOSER_HOME=/vagrant",
}

# sub-manifests
import 'apt_packages.pp'
import 'bashrc.pp'
import 'motd.pp'
import 'nginx.pp'
import 'php.pp'
import 'mysql.pp'
import 'nodejs.pp'
import 'ruby_and_gems.pp'
import 'capistrano.pp'
import 'cakecore.pp'
