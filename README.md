# Doorkeeper Sequel ORM extension

:fire: :fire: **USE WITH CAUTION ! CURRENTLY IS UNDER DEVELOPMENT!** :fire: :fire:

Current version of Doorkeeper-Sequel ORM _is not tested well yet_. If you have desire and time for this - you are welcome!

Compatible with Doorkeeper 4.0.0.rc3: _554_ examples, _11_ failures. Release is very soon!

## Installation

doorkeeper-sequel provides [Doorkeeper](https://github.com/doorkeeper-gem/doorkeeper) support to [Sequel](https://github.com/jeremyevans/sequel).
To start using it, add to your Gemfile:

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
rails generate doorkeeper_sequel:migration
```

## Requirements

* Doorkeeper >= 4.0
* Rails >= 4.2 (Doorkeeper dropped support of lower versions)
* Sequel >= 4

## Tests

To run tests, clone this repository and run `rake`. It will copy and run
doorkeeper’s original test suite, after configuring the ORM according to the
variables defined in `.travis.yml` file.

```
$ bundle exec rake
```

## License

Doorkeeper-sequel gem is released under the [MIT License](http://www.opensource.org/licenses/MIT).

Copyright (c) 2016 Nikita Bulaj (bulajnikita@gmail.com).

---

Please refer to https://github.com/doorkeeper-gem/doorkeeper for instructions on
doorkeeper’s project.
