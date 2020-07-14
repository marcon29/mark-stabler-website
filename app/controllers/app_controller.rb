class AppController < Sinatra::Base
	configure do
		set :views, "app/views/"
		set :public_folder, "public"
		enable :sessions
		set :session_secret, "mswoccp"
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

	post '/contact' do
        # process contact form
                
		# if # email sent
		# 	flash[:message] = "Your message was sent. I'll get back to you as soon as possible."
        # else
        #     flash[:message] = "There was a problem sending your message. Looks like I owe you a beer. Please submit again."
		# end
		
		# redirect back
    end



	# app helpers ###############################
	# add helpers used in numerous controllers

	
	
	# model helpers ###############################
	# add helpers used in specific controller



	# user helpers ###############################
	def login(user)
		if user && user.authenticate(params[:user][:password])
			session[:user_id] = user.id
		else
			# flash[:message] = "We did not find a matching profile. Please sign up instead."
			redirect '/admin'
		end		
	end
	
	def current_user
		User.find(session[:user_id])
	end

	def logged_in?
		!!session[:user_id]
	end

	def logout!
		session.delete(:user_id)
	end



end
