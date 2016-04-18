# Doorkeeper Sequel ORM extension

:fire: :fire: **DONT USE IT! CURRENTLY IS UNDER DEVELOPMENT!** :fire: :fire:

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
rails generate doorkeeper:sequel:migration
```

## License

Doorkeeper-sequel gem is released under the [MIT License](http://www.opensource.org/licenses/MIT).

Copyright (c) 2014-2016 Nikita Bulaj (bulajnikita@gmail.com).
