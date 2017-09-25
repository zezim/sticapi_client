# SticapiClient

A Client to use TJPI sticapi services, web services for TJPI application integrations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sticapi_client'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install sticapi_client
```

## Usage

Generate config file

```bash
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

In your application_controller (or in controllers you want to use sticapi functions) add:

```ruby
include SticapiController
```

to manipulate tokens sent and received from sticapi server

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zezim/sticapi_client.
