# install cakephp core files
class { 'cakeCore':
    appRoot    => "${settings::ymlconfig[env][docRoot]}",
    cakeRoot   => "${settings::ymlconfig[cake][corePath]}",
    cakeTag    => "${settings::ymlconfig[cake][repoTag]}",
    db_user    => "${settings::ymlconfig[mysql][user]}",
    db_pass    => "${settings::ymlconfig[mysql][pass]}",
    db_name    => "${settings::ymlconfig[mysql][name]}";
}
