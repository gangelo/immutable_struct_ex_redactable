# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in immutable_struct_ex_redactable.gemspec
gemspec

gem 'bundler', '>= 2.5', '< 3.0'
gem 'rake', '>= 13.0', '< 14.0'

group :development do
  gem 'reek', '>= 6.1', '< 7.0'
  gem 'rubocop', '>= 1.65', '< 2.0'
  gem 'rubocop-performance', '>= 1.21', '< 2.0'
  gem 'rubocop-rake', '>= 0.6', '< 1.0'
  gem 'rubocop-rspec', '>= 3.0.4', '< 4.0'
end

group :test do
  gem 'rspec', '>= 3.12', '< 4.0'
  gem 'simplecov', '>= 0.22.0', '< 1.0'
end

group :development, :test do
  gem 'pry-byebug', '>= 3.9', '< 4.0'
end
