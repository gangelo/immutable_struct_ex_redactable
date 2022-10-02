# `immutable_struct_ex_redactable`

[![GitHub version](http://badge.fury.io/gh/gangelo%2Fimmutable_struct_ex_redactable.svg)](https://badge.fury.io/gh/gangelo%2Fimmutable_struct_ex_redactable)

[![Gem Version](https://badge.fury.io/rb/immutable_struct_ex_redactable.svg)](https://badge.fury.io/rb/immutable_struct_ex_redactable)

[![](http://ruby-gem-downloads-badge.herokuapp.com/immutable_struct_ex_redactable?type=total)](http://www.rubydoc.info/gems/immutable_struct_ex_redactable/)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://www.rubydoc.info/gems/immutable_struct_ex_redactable/)

[![Report Issues](https://img.shields.io/badge/report-issues-red.svg)](https://github.com/gangelo/immutable_struct_ex_redactable/issues)

[![License](http://img.shields.io/badge/license-MIT-yellowgreen.svg)](#license)

## Introduction

`immutable_struct_ex_redactable` is the *redactable version* of the world-famous *immutable_struct_ex* immutable struct :). To find out more about the *immutable_struct_ex* gem, visit the Rubygems.org entry for [immutable_struct_ex](https://rubygems.org/gems/immutable_struct_ex).

`immutable_struct_ex_redactable` maintains all the functionality of the *immutable_struct_ex* gem, but allows you to create immutable structs that can be configured to redact field values using standard gem configuration (`ImmutableStructExRedactable.configure { |config| ... }`) or by passing configuration options to the appropriate method (`ImmutableStructExRedactable.create_with(config, ...)`)

## Usage

Follow the instructions for [Installation](#installation) first, to incorporate this gem into your code.

### Enhancements
- Future functionality may include regex pattern for redacting field values (e.g. 'gen***@***.com').
- Availability of redacted values as private fields/methods for use in `&blocks`.

### Basic usage

#### Configure Gem Global Defaults

*immutable_struct_ex_redactable*, by default, will redact fields named `:password` using the redacted label `"******"`. This will not meet your needs in all circumstances most likely. If this is *not* the case, you may change the default redactable fields and redactable label by changing the *immutable_struct_ex_redactable* configuration as follows:

```ruby
ImmutableStructExRedactable::configure do |config|
  config.redacted = %i[password dob ssn phone]
  config.redacted_label = '[REDACTED]'
end

fields = {
  first: 'John',
  last: 'Smith',
  password: 'p@ssw0rd',
  dob: '1986-05-12'
}

ImmutableStructExRedactable.create(**fields)
=> #<struct  first="John", last="Smith", password="[REDACTED]", dob="[REDACTED]">

fields = {
  first: 'Jane',
  last: 'Smith',
  password: 'h3l10W04lD',
  dob: '1990-12-26'
}

ImmutableStructExRedactable.create(**fields)
=> #<struct  first="Jane", last="Smith", password="[REDACTED]", dob="[REDACTED]">

```
NOTE: Setting the global defaults in the above manner will affect **every** *immutable_struct_ex_redactable* struct you create unless you override the global configuration options by passing a custom configuration.

#### Overriding the Global Configuration Operions

To override the global configuration options, you may do so by calling the `ImmutableStructExRedactable#create_with` method in the following manner:

```ruby
# Create a custom configuration with the options you want to use.
custom_config = ImmutableStructExRedactable::Configuration.new.tap do |config|
  config.redacted = %i[password dob]
  config.redacted_label = '[NO WAY JOSE]'
end

fields = {
  first: 'John',
  last: 'Smith',
  password: 'p@ssw0rd',
  dob: '1986-05-12'
}

# Call the #create_with method passing the custom configuration options.
ImmutableStructExRedactable.create_with(custom_config, **fields)
=> #<struct  first="John", last="Smith", password="[NO WAY JOSE]", dob="[NO WAY JOSE]">
```

### &blocks are Permitted

Current `immutable_struct_ex` gem functionality is still available, so passing `&block` is permitted. See [immutable_struct_ex](https://rubygems.org/gems/immutable_struct_ex) gem for more details:

```ruby
fields = { first: 'John', last: 'Smith', password: 'p@ssw0rd' }

struct = ImmutableStructExRedactable.create(**fields) do
  def full_name
    "#{first} #{last}"
  end
end

struct.full_name
=> "John Smith"
```

### Miscellaneous Examples

```ruby
class MyRedactableImmutableStruct
  include ImmutableStructExRedactable

  class << self
    def create
      self.new.send(:execute)
    end
  end

  private

  attr_reader :results

  def execute
    @results ||= create_with(config, username: 'jsmith', password: 'p@ssw0rd') do
      def jsmith?
        username == 'jsmith'
      end
    end
  end

  def config
    @config ||= ImmutableStructExRedactable::Configuration.new.tap do |config|
      config.redacted = %i[password]
      config.redacted_label = 'xxxxxx'
    end
  end
end

results = MyRedactableImmutableStruct.create
#=> #<struct  username="jsmith", password="xxxxxx">

results.jsmith?
#=> true
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'immutable_struct_ex_redactable'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install immutable_struct_ex_redactable

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/immutable_struct_ex_redactable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/immutable_struct_ex_redactable/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ImmutableStructExRedactable project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/immutable_struct_ex_redactable/blob/main/CODE_OF_CONDUCT.md).
