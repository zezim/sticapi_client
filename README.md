# SticapiClient

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/sticapi_client`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sticapi_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sticapi_client

## Usage

Generate config file

```ruby
rails generate sticapi_client:install
```

Configure data for your sticpai server

```yml
development:
  host: localhost
  port: 3001
  user: user_of_sticapi
  password: password_of_sticapi

test:
  host: localhost
  port: 3001
  user: user_of_sticapi
  password: password_of_sticapi

production:
  host: localhost
  port: 3001
  user: user_of_sticapi
  password: password_of_sticapi
```

In your application_controller add:

```ruby
include SticapiController
```

to manipulate tokens sent and received from sticapi server

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zezim/sticapi_client.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
