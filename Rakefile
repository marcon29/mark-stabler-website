ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'

desc 'Starts Rake console'
task :console do
    Pry.start
end

namespace :db do
    desc 'Clears all tables'
    task :clear_all do
        ContentSection.destroy_all
        SocialPlatform.destroy_all
        SocialProfile.destroy_all
        User.destroy_all
    end

    desc 'Clears content_sections table'
    task :clear_content do
        ContentSection.destroy_all
    end

    desc 'Clears social_platforms table'
    task :clear_social_platforms do
        SocialPlatform.destroy_all
    end

    desc 'Clears social_profiles table'
    task :clear_social_profiles do
        SocialProfile.destroy_all        
    end

    desc 'Clears users table'
    task :clear_users do
        User.destroy_all
    end
end

def reload!
    load_all './app'
end

def clear_all!
    ContentSection.destroy_all
    SocialPlatform.destroy_all
    SocialProfile.destroy_all
    User.destroy_all
end

