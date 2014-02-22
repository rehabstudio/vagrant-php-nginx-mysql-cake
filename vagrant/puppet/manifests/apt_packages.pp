# Adding extra PPA's for more up to date software.
class { 'apt': }
apt::ppa { 'ppa:git-core/ppa': }

# latest stable git
if ! defined(Package['git']) { 
    package { 'git':
        ensure => installed, 
        name => 'git-core',
        require => Apt::Ppa['ppa:git-core/ppa']
    }
}

# vim editor
if ! defined(Package['vim']) { 
    package { 'vim':
        ensure => installed
    }
}

# augeas support
if ! defined(Package['libaugeas-ruby']) { 
    package { 'libaugeas-ruby':
        ensure => installed
    }
}
if ! defined(Package['augeas-tools']) { 
    package { 'augeas-tools':
        ensure => installed
    }
}

# in-memory cache
if ! defined(Package['memcached']) { 
    package { 'memcached':
        ensure => installed
    }
}

# compression support
if ! defined(Package['unzip']) { 
    package { 'unzip':
        ensure => installed
    }
}
if ! defined(Package['zip']) { 
    package { 'zip':
        ensure => installed
    }
}
