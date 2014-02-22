# Adding extra PPA's for more up to date software.
class { 'apt': }
apt::ppa { 'ppa:git-core/ppa': }

# Installing other useful packages.
package { [
    # latest stable git
    'git-core',
    # vim 'cos vim
    'vim',
    # augeas support
    'libaugeas-ruby',
    'augeas-tools',
    # in-memory cache
    'memcached',
    # because we need to uncompress things
    'unzip',
    'zip'
]:
    ensure => present,
    require => Apt::Ppa['ppa:git-core/ppa']
}
