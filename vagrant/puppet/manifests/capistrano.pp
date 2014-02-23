# simple class that installs the gem dependecies and creates the core capistrano configuration used as part of the quick-deploy process
class { 'capistrano':
    application    => "myapp",
    repo           => "${settings::ymlconfig[capistrano][repo]}",
    branch_dev     => "${settings::ymlconfig[capistrano][branch][dev]}",
    branch_staging => "${settings::ymlconfig[capistrano][branch][staging]}",
    branch_live    => "${settings::ymlconfig[capistrano][branch][live]}",
    directory      => "${settings::ymlconfig[capistrano][folder]}",
    server_user    => "${settings::ymlconfig[capistrano][server_user]}",
    server_ip      => "${settings::ymlconfig[capistrano][server_ip]}"
}
