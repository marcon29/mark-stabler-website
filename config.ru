ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'

if ActiveRecord::Base.connection.migration_context.needs_migration?
    raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use ContentSectionslController
use SocialPlatformslController
use SocialProfileslController
use UsersController
run AppController 