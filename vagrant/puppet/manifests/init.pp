include 'stdlib'

# global settings class
class settings {
    $ymlconfig = loadyaml('/vagrant/config.yml')
}

# Adding a global exec statement so we don't have to add paths to every one.
Exec {
    path => ['/bin', '/sbin', '/usr/bin', '/usr/local/bin', '/usr/sbin']
}

# sub-manifests
import 'apt_packages.pp'
import 'bashrc.pp'
import 'motd.pp'
import 'nginx.pp'
import 'php.pp'
import 'nodejs.pp'
import 'apt_packages.pp'
import 'ruby_and_gems.pp'
import 'cakecore.pp'