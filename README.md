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
* install gems with  ``` bundle install ``` (do not use sudo to install gems)
* install node packages:

  ```bash
  sudo apt-get update && sudo apt-get install yarn
  yarn install
  ```

* setup mysql:

  ```bash
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
* Run ``` rails credentials:edit ``` to configure database login and password if neccessary
* Run ``` rails generate delayed_job:active_record ``` to setup DelayJob if there is error about it (should not be neccessary)
* Run ``` rails db:create ``` for the first time
* Make sure the database is updated to the latest schema with ``` rails db:migrate ```
* Make sure the assets are compiled by running ``` rails assets:precompile ```
* Run server with ``` rails s --environment=production ``` with other options if needed. (not neccessary for apache integration)
* Run background worker for Database sync with ``` nohup rake jobs:work & ```

## Database initialization

* Database seed setup avaliable in ``` db/seeds.rb ```
* Run Database seeding with ``` rails db:seed ```

## How to run the test suite

* Run available tests with ``` rails test ```
* Test coverage is minimal, with OldDb sync tests located in test/integration

## Services (job queues, cache servers, search engines, etc.)

* OldDb synchronization can be triggered manually in console with ``` OldDb.sync ```, or scheduled to run with background worker (already configured).
* ```Department```, ```Student```, ```Supervisor```, ```Todo``` tables uses timestamp-based synchronization (the one with newer timestamp overrides the other), while ```Faculty``` and ```Unversity``` is one-sided sync from the OldDb.
* After synchronization, updates in this application will also update OldDb (except Faculty and University).
