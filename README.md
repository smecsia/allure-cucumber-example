# Allure Cucumber Demo

This is a demo of Allure Cucumber abilities

## Prerequisites

* Ruby. It's better to install it with [RVM](https://rvm.io/)
* [Docker](https://docs.docker.com/install/). Needed to launch Selenium with Chrome and Firefox browsers.
* [JRE](https://www.java.com/en/download/). Required to run Allure Commandline tool.

## Installing dependencies
    
    gem install bundler
    bundle install
    
## Running tests

    rake test
    
## Building report

    rake report
    
 After building the report you can access it by opening the following file in the browser:
 
    ./build/allure-repot/index.html