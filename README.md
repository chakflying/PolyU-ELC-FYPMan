# README

this is the repo for the PolyU FYP management system. It uses Ruby on Rails as the backend and Vue.js as some of the frontend.

## Ruby version
``` ruby 2.6.1 ```

## System dependencies
The Dev environment is setup in Linux Subsystem for Windows,  ``` Ubuntu 18.04.1 LTS ```.

The deploy branch is setup to auto deploy to a SUSE 12 staging server.

Node.js should be installed, perferably with at least the latest version of 8.X.X

``` nvm ls ``` will list the installed Node versions.


## Initial Configuration
* clone the repository
* install ruby 2.6.1
* install gems with  ``` bundle install ```
* install node packages:
    ```
    sudo apt-get update && sudo apt-get install yarn
    yarn install
    ```
* setup mysql:
    ```
    sudo apt-get update
    sudo apt-get install mysql-server
    sudo mysql_secure_installation
    rails db:create
    rails db:migrate
    ```
* run server with ``` rails s ```, and webpack server for development with ``` ./bin/webpack-dev-server ```

## Deployment instructions
* Same as local configuration
* Setup apache passenger intergration ([reference](https://www.phusionpassenger.com/library/install/apache/install/oss/rubygems_rvm/)) and configure Apache VirtualHost to the cloned directory
* Modify ```database.yml``` for platform specific settings
* Make sure the database is updated to the latest schema with ``` rails db:migrate ```
* Make sure the assets are compiled by running ``` rails assets:precompile ```
* Run server with ``` rails s --environment=production ``` with other options if necessary.

## Database initialization

## How to run the test suite

## Services (job queues, cache servers, search engines, etc.)

