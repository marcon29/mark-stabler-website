source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

group :production do
    gem 'sinatra'
    gem 'activerecord', '~> 5.2.3', require: 'active_record'
    gem 'sinatra-activerecord'
    gem 'sqlite3'
    gem 'bcrypt'
    gem 'rack-flash3'
    gem 'require_all'
end

group :development do
    gem 'sinatra-reloader'
    gem 'pry'
    gem 'shotgun'
    gem 'thin'
    gem 'tux'
    gem 'rake'
end

group :test do
    gem 'rspec'
    gem 'capybara'
    gem 'rack-test'
    gem 'database_cleaner'
end