# Doorkeeper Sequel ORM extension

:fire: :fire: **USE WITH CAUTION ! CURRENTLY IS UNDER DEVELOPMENT!** :fire: :fire:

Current version of Doorkeeper-Sequel ORM is not tested well yet. If you have desire and time for this - you are welcome!

## Installation

doorkeeper-sequel provides Doorkeeper support to Sequel.
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

## License

Doorkeeper-sequel gem is released under the [MIT License](http://www.opensource.org/licenses/MIT).

Copyright (c) 2016 Nikita Bulaj (bulajnikita@gmail.com).
