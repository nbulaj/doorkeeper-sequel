# Doorkeeper Sequel ORM extension
[![Build Status](https://travis-ci.org/nbulaj/doorkeeper-sequel.svg?branch=master)](https://travis-ci.org/nbulaj/doorkeeper-sequel)
[![Dependency Status](https://gemnasium.com/nbulaj/doorkeeper-sequel.svg)](https://gemnasium.com/nbulaj/doorkeeper-sequel)
[![Code Climate](https://codeclimate.com/github/nbulaj/doorkeeper-sequel/badges/gpa.svg)](https://codeclimate.com/github/nbulaj/doorkeeper-sequel)
[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg)](#license)

`doorkeeper-sequel` provides [Doorkeeper](https://github.com/doorkeeper-gem/doorkeeper) support to [Sequel](https://github.com/jeremyevans/sequel) database toolkit.

## Requirements

* Doorkeeper >= 4.0
* Rails >= 4.2 (Doorkeeper dropped support of lower versions)
* Sequel >= 4

## Installation

To start using the Doorkeeper Sequel ORM, add to your Gemfile:

``` ruby
gem 'doorkeeper-sequel', github: 'nbulaj/doorkeeper-sequel'
```

Set the Doorkeeper ORM configuration:

``` ruby
Doorkeeper.configure do
  orm :sequel
end
```

Generate migrations:

```
rails generate doorkeeper:sequel:migration
rails generate doorkeeper:sequel:application_owner
rails generate doorkeeper:sequel:previous_refresh_token
```

## Tests

To run tests, clone this repository and run `rake`. It will copy and run
doorkeeper’s original test suite, after configuring the ORM and other stuffs.

```
$ bundle exec rake
```

## License

Doorkeeper-sequel gem is released under the [MIT License](http://www.opensource.org/licenses/MIT).

Copyright (c) 2016 Nikita Bulaj (bulajnikita@gmail.com).

---

Please refer to https://github.com/doorkeeper-gem/doorkeeper for instructions on
doorkeeper’s project.
