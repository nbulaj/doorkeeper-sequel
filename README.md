# Doorkeeper Sequel ORM extension

**DONT USE IT! CURRENTLY IS UNDER DEVELOPMENT!**

## Installation

doorkeeper-sequel provides doorkeeper support to Sequel.
To start using it, add to your Gemfile:

``` ruby
gem 'doorkeeper-sequel', github: 'nbulaj/doorkeeper-sequel'
```

Set the Doorkeeper ORM configuration:

``` ruby
Doorkeeper.configure do
  orm :sequel
end

## License

Alpha Card gem is released under the [MIT License](http://www.opensource.org/licenses/MIT).

Copyright (c) 2014-2016 Nikita Bulaj (bulajnikita@gmail.com).
