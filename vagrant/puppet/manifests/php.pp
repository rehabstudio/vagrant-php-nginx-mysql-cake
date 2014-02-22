# Including necessary classes for installing PHP.
include php

# Installing FPM and PEAR separately as they have extra functionality.
class {
    'php::fpm':
        ensure => installed;
    'php::pear':
        ensure => installed;
}

# Installing PHP Extensions.
php::extension { 'php-extensions':
    ensure => installed,
    package => [
        'php5-curl', 'php5-dev',
        'php5-gd', 'php5-imagick', 'php5-mcrypt',
        'php5-mysql', 'php5-pspell', 'php5-xdebug',
        'php5-xmlrpc', 'php5-tidy', 'php5-xsl'
    ],
    notify => Service['php5-fpm'];
}

# Installing PHPUnit via Pear.
package { 'pear.phpunit.de/PHPUnit':
    ensure   => present,
    provider => pear,
    require  => [Package['php-pear'], Exec['php::pear::auto_discover']];
}

# Updating particular settings in the ini file without doing a file overwrite.
augeas { 'php.ini':
    notify => Service['php5-fpm'],
    require => [Package['libaugeas-ruby'], Package['augeas-tools'], Package['php5-fpm']],
    context => '/files/etc/php5/fpm/php.ini',
    changes => $settings::ymlconfig['php']['iniOverrides']
}
