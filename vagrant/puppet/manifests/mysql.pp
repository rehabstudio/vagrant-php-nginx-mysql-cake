# Installing MySQL server and updating the root users password.
class { '::mysql::server':
    root_password => 'j1h34SADjh134n',
    restart       => true,
    override_options => {
        'mysqld' => {
            'bind-address' => $settings::ymlconfig['env']['ip']
        }
    }
}

# Adding project database schema to the MySQL database.
mysql::db { $settings::ymlconfig['mysql']['name']:
    grant    => ['ALL'],
    user     => $settings::ymlconfig['mysql']['user'],
    password => $settings::ymlconfig['mysql']['pass'],
    sql      => $settings::ymlconfig['mysql']['file'],
    require  => Class['mysql::server']
}

# Ensuring the user is added as a wildcard.
mysql_user { "${settings::ymlconfig[mysql][user]}@%":
    password_hash => mysql_password("${settings::ymlconfig[mysql][pass]}"),
    require       => Class['mysql::server']
}

# Ensuring the users privileges are correct.
mysql_grant { "${settings::ymlconfig[mysql][user]}@%/${settings::ymlconfig[mysql][name]}":
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => '*.*',
    user       => "${settings::ymlconfig[mysql][user]}@%",
    require    => Class['mysql::server']
}
