# Wizlist

Wizlist is an app that allows creating and managing a basic gift registry.
Wizlist is being developed during the Ragnarson's 2016 Internship program.

## Functionality:

See: [list of user stories](doc/user_stories.md).

## Check out the demo on Heroku:

https://wizlist.herokuapp.com

## Getting started:

### Dependencies:

We're developing in Ruby version `2.3.1`, and assume you have a working Ruby
environment and a PostgreSQL installed. On macOS you can install it using
[Homebrew](http://brew.sh):

    brew update
    brew install postgres

And on Debian based distros:

    sudo apt-get update
    sudo apt-get install postgresql postgresql-contrib libpq-dev

Update `rubygems` and install [`Bundler`](http://bundler.io):

    gem update --system
    gem update
    gem install bundler

App's dependencies can be installed by executing in app's root dir:

    bundle install

With all dependencies installed and the PostgreSQL running, we can set up our
database:

    bundle exec rails db:setup

### Development:

Running tests suite:

    bundle exec rails spec

Starting development server:

    bundle exec rails server

### Contributing

See: [GitHub Workflow](doc/github_workflow.md)

## Authors:

* [Kacper Brańka](https://github.com/Kacper3331)
* [Tomasz Cudziło](https://github.com/student-tomasz)
* [Kamil Dębicki](https://github.com/kamil506)
* [Alicja Gałkiewicz](https://github.com/agalkiewicz)
* [Adrian Korzeniowski](https://github.com/Schocker)
* [Magdalena Nodzyńska](https://github.com/nodzy)
* [Shadi Rezek](https://github.com/shadrk)
