include php
include php::apt
include php::composer

class {
  'php::cli':
    ensure => present;
  'php::dev':
    ensure => present;
  'php::pear':
    ensure => present;
  'php::extension::apc':
    ensure => present;
  'php::fpm':
    ensure => present;
}

# installing PHP Extensions.
php::extension { 'php-extensions':
    ensure => installed,
    package => [
        'php5-curl', 'php5-gd', 'php5-imagick', 'php5-mcrypt',
        'php5-mysql', 'php5-pspell', 'php5-xdebug',
        'php5-xmlrpc', 'php5-tidy', 'php5-xsl'
    ],
    notify => Service['php5-fpm'];
}

# updating particular settings in the ini file without doing a file overwrite.
augeas { 'php.ini':
    notify => Service['php5-fpm'],
    require => [Package['libaugeas-ruby'], Package['augeas-tools'], Package['php5-fpm']],
    context => '/files/etc/php5/fpm/php.ini',
    changes => $settings::ymlconfig['php']['iniOverrides']
}

# phpunit
package { 'pear.phpunit.de/PHPUnit':
    ensure   => '3.7.12',
    provider => pear,
    require  => Exec['php::pear::auto_discover'];
}

# adding github oath to composer
exec { 'Adding github oath':
    cwd       => $settings::ymlconfig['env']['docRoot'],
    command   => "composer config github-oauth.github.com ${settings::ymlconfig[github][oauth]}",
    logoutput => true,
    require   => Class['php::composer'],
    onlyif    => "test -f ${settings::ymlconfig[env][docRoot]}/composer.json"
}

# execute composer if json is found
exec { 'Installing Composer Packages':
    cwd       => $settings::ymlconfig['env']['docRoot'],
    command   => 'composer install',
    logoutput => true,
    require   => Class['php::composer'],
    onlyif    => "test -f ${settings::ymlconfig[env][docRoot]}/composer.json"
}
