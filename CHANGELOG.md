# Doorkeeper-Sequel ORM 1.x Changelog

Reverse Chronological Order:

## master

https://github.com/nbulaj/doorkeeper-sequel/compare/1.2.2...master

...

## `1.2.2` (2017-06-07)

https://github.com/nbulaj/doorkeeper-sequel/compare/1.2.1...1.2.2

* ORM code refactoring
* Fix Sequel deprecations (>= 4.47)
* Update Doorkeeper submodule (support up to 4.2.6)
* Fix `#table_exists?` method for models
* `Rakefile` refactoring
* Remove Gemfile.lock

## `1.2.1` (2016-10-12)

https://github.com/nbulaj/doorkeeper-sequel/compare/1.2.0...1.2.1

* Association dependencies changed to `:delete` instead of `:destroy` (in accordance to Doorkeeper)
* Fixed generators and specs for it
* Code refactoring with [rubocop](https://github.com/bbatsov/rubocop)
* No braking changes

## `1.2.0` (2016-09-05)

https://github.com/nbulaj/doorkeeper-sequel/compare/1.0.0...1.2.0

* Added compatibility with Doorkeeper 4.2
* No braking changes

## `1.0.0` (2016-05-17)

* First stable release
* Compatible with Doorkeeper >= 4.x and Rails >= 4.x
