# UmtsCustomMatchers

Custom RSpec Rails-related matchers, used for UMass Transit's internal Rails development process.

Primary contributor is @dfaulken.

Much of the inspiration for these solutions came from inspection of the rspec-rails source code, so thanks to the rspec-rails team for making their source code public.

[![Build Status](https://travis-ci.org/umts/custom-matchers.svg?branch=master)](https://travis-ci.org/umts/custom-matchers)
[![Test Coverage](https://codeclimate.com/github/umts/custom-matchers/badges/coverage.svg)](https://codeclimate.com/github/umts/custom-matchers/coverage)
[![Code Climate](https://codeclimate.com/github/umts/custom-matchers/badges/gpa.svg)](https://codeclimate.com/github/umts/custom-matchers)
[![Issue Count](https://codeclimate.com/github/umts/custom-matchers/badges/issue_count.svg)](https://codeclimate.com/github/umts/custom-matchers)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'umts-custom-matchers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install umts-custom-matchers

## Usage

Require the matchers in your RSpec configuration file:

```ruby
require 'umts-custom-matchers'
```

And include them:

```ruby
RSpec.configure do |config|
  # ...
  config.include UmtsCustomMatchers
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/umts-custom-matchers.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
