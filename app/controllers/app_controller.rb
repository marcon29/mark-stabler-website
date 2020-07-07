class AppController < Sinatra::Base
	configure do
		set :views, "app/views/"
		set :public_folder, "public"
		# enable :sessions
		# set :session_secret, "woccpms"
	end

	# home page
	get '/' do
        # redirect '/subjects' if logged_in?
		erb :index
    end



end
