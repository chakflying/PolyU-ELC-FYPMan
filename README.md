# README

this is the repo for the PolyU FYP management system. It uses Ruby on Rails as the backend and Vue.js as some of the frontend.

## Ruby version
``` ruby 2.5.1 ``` and ``` rails 5.2.1 ```

## System dependencies
this repo is setup in Linux Subsystem for Windows. 
Compatibility with other Linux install is untested.

``` Ubuntu 16.04.4 LTS ```


## Initial Configuration
* clone the repository
* install ruby 2.5.1
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
* run server with ``` rails s --environment=development ``` 

## Deployment instructions
* Same as local configuration
* Modify ```database.yml``` for platform specific settings
* Make sure the database is updated to the latest schema with ``` rails db:migrate ```
* Run server with ``` rails s --environment=production ``` with other options if necessary.

## Database initialization

## How to run the test suite

## Services (job queues, cache servers, search engines, etc.)

