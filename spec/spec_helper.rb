ENV["SINATRA_ENV"] = "test"

require_relative '../config/environment'
require 'rack/test'
require 'capybara/rspec'
require 'capybara/dsl'

if ActiveRecord::Base.connection.migration_context.needs_migration?
  raise 'Migrations are pending run `rake db:migrate SINATRA_ENV=test` to resolve the issue.'
end

# these control the display results (turns off showing all the damn query results)
# ActiveRecord::Base.logger.level = 1
ActiveRecord::Base.logger = nil

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  
  config.include Rack::Test::Methods
  config.include Capybara::DSL
  DatabaseCleaner.strategy = :truncation
  
  config.before do
    DatabaseCleaner.clean
  end
  
  config.after do
    DatabaseCleaner.clean
  end

  config.order = 'default'  
end

def app
  Rack::Builder.parse_file('config.ru').first
end

def visit_admin_and_login_user
  visit '/admin'
  login_user
end

def login_user
	fill_in :username, :with => "testuser1"
	fill_in :password, :with => "test"
	click_button "Log In"
end

def logout_user
	click_link "Log Out"
end

def testable_base_url(base_url)
  string = base_url.gsub(/(https:\/\/|http:\/\/)?(www.)?/, "").strip.downcase

  if string.ends_with?('/')
      string = "www.#{string}"
  else
      string = ("www.#{string}/")
  end
end

def testable_handle(handle)
  string = handle.gsub(/[@ ]/, "").downcase
  
  if string.scan(/[^\w\-_\.]/).empty?
      handle = string.gsub(/[@ ]/, "").downcase
  else
      handle = ""
  end
end

Capybara.app = app