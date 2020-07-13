class AppController < Sinatra::Base
	configure do
		set :views, "app/views/"
		set :public_folder, "public"
		# enable :sessions
		# set :session_secret, "mswoccp"
	end

	# home page
	get '/' do
		erb :index
	end

	# contact page
	get '/contact' do
		@contact_email = "online@markstabler.com"
		erb :contact
	end



end
