PHP/NGINX/MySQL VAGRANT BOX
===========================

Simple vagrant build for a general php/mysql setup on nginx. This will boot up an nginx/php/mysql ubuntu box for a single instance. It uses host manager for easy local DNS configuration.

This particular box also installs some [CakePHP](https://github.com/cakephp/cakephp) and [Capistrano](https://github.com/capistrano/capistrano) dependencies.

Requirements
------------

- [Virtualbox 4.2](https://www.virtualbox.org)
- [Vagrant 1.4](http://www.vagrantup.com)
- [Vagrant Vbguest Plugin](https://github.com/dotless-de/vagrant-vbguest)
- [Vagrant Hostmanager Plugin](https://github.com/smdahlen/vagrant-hostmanager)

Installation
-------

1. Navigate inside the vagrant folder and create the guest machine
`cd vagrant && vagrant up`

2. After the installation finishes, visit the chosen domain:
`http://rehab.vagrant.local`

Customisation
------------

A single YAML configuration file can be found in `vagrant/config.yml` which will contain the majority of common settings that you will wish to tweak per project.

The Vagrantfile `vagrant/Vagrantfile` and main puppet manifest `vagrant/puppet/manifests/init.pp` have a variety of configuration options at the top of their files that should be tweaked per project. Some of the configuration options affect things such as the bound ip address of the box, vhost settings, nginx log locations, database users, php settings and much more.

By default, MySQL has a root user whose password is also root. A project-specific user is also created, whose credentials can be set via the supplied configuration options. A schema is also imported on your behalf which can be found at `vagrant/files/db_schema.sql`. Replace the existing schemawith your own, or, repoint the schema path to a different one. It is important to ensure your schema uses `IF NOT EXISTS` statements to ensure data is not overwritten when reprovisioning your box.

Alongside PHP being installed, [PHPUnit](http://phpunit.de/) and [Composer](https://getcomposer.org/) are already present. PHP settings are changed using a tool known as [Augeas](http://augeas.net/) which has a specific syntax to follow. This should be taken into consideration if you are wanting to change ini settings other than those already listed/changed. You can also change the installed extensions by finding the `php::extension` declaration.

It should also be noted that this is just a base for you to build upon. These scripts should be adapted to best suit your project and to mirror your live location as closely as possible.


Adding Modules
--------------

This vagrant setup utilises [Librarian-Puppet](https://github.com/rodjek/librarian-puppet) as a package manager for the Puppet modules. All modules should be added to the repository using this method.

MySQL Access
------------

MySQL can be accessed internally on the box by SSHing into it using `vagrant ssh`, or, by using a desktop client (or command-line) from your host machine. The MySQL server package has been pre-configured to allow access from your remote machine using a combination of the private IP address from vagrant and the generated users credentials. You can connect using a command (from your host machine) like the following:

``` bash
mysql --host=192.168.33.10 --user=username --password=password
```

Node Dependencies
------------

There is a statement included in the puppet files to search your `$siteRoot` for a `package.json` file. If one is found, then the command `npm install` will be run on your behalf. The longer a project runs the more likely its dependencies will change. If you add or remove packages from your `package.json` file, simply run `vagrant provision` to have it re-run the `npm install` command.

Composer Dependencies
------------

Similar to Node, puppet will search your `$siteRoot` for a `composer.json` file. If one is found, then the command `composer install` will be run on your behalf. If there are any changes throughout the lifetime of the project, be sure to manually delete any composer lock files before re-provisioning using the command `vagrant provision`.

