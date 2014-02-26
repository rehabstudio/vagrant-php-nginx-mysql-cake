# Installing nginx package and setting up its conf file.
class { 'nginx':
    server_tokens => 'off',
    nginx_error_log => $settings::ymlconfig['nginx']['errorLog'],
    http_access_log => $settings::ymlconfig['nginx']['accessLog'];
}

# Adding a vhost file for the project.
nginx::resource::vhost { $settings::ymlconfig['env']['domain']:
    www_root => "${settings::ymlconfig[env][docRoot]}${settings::ymlconfig[env][siteRoot]}",
    error_log => $settings::ymlconfig['nginx']['errorLog'],
    access_log => $settings::ymlconfig['nginx']['accessLog'],
    index_files => ['index.php', 'index.html'],
    vhost_cfg_prepend => {
        'sendfile' => 'off' # http://jeremyfelt.com/code/2013/01/08/clear-nginx-cache-in-vagrant/
    },
    try_files => ['$uri', '$uri/', '/index.php?$args'];
}

# fastcgi parameters
# Note: this seems to be broken in the nginx module - it implodes the arrays to create a long one-line string. I've manually added newlines, semi-colons and 'fastcgi_params' here to work around it
$fastcgi_param = [
    "APPLICATION_ENV local;\n",
    "fastcgi_param TIMEZONE Europe/Belfast;\n",
    "fastcgi_param PHP_VALUE include_path=.:/usr/share/php:/usr/share/pear:${settings::ymlconfig[cake][corePath]}/lib:/usr/share/php/PHPUnit"
]

# Pushing all PHP files to FastCGI Process Manager (php5-fpm).
nginx::resource::location { "${settings::ymlconfig[env][domain]} php files":
    vhost => $settings::ymlconfig['env']['domain'],
    www_root => "${settings::ymlconfig[env][docRoot]}${settings::ymlconfig[env][siteRoot]}",
    fastcgi => '127.0.0.1:9000',
    location => '~ \.php$',
    location_cfg_append => {
        'fastcgi_index' => 'index.php',
        'fastcgi_param' => $fastcgi_param,
    },
    notify => Class['nginx::service'];
}

# Ensuring the www-data user is part of the vagrant group so files can be modified.
user { 'www-data':
    groups => ['vagrant'],
    notify => Class['nginx::service']
}
