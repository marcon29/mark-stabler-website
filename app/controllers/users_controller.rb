# require 'rack-flash'

class UsersController < AppController
	# use Rack::Flash
    
	# admin home page ###############################################
	# this route for CMS home - don't need this if redirecting to a content page for web app
	# make this the login/signup home page if not logged in (users/index)
	# make gateway to all other functionality if logged in (users/admin)
	get '/admin' do
		# test
		"hello world from admin home page from users_controller"

	        # erb :"/users/index" if !logged_in?
	        # erb :"/users/admin"
	end
    
	# signup routes ################################################
	get '/signup' do
		# test
		"hello world from signup route of users_controller"

		# redirect "/admin" if logged_in?
		# erb :"users/signup"
	end

	post '/signup' do
		# user = User.new(params[:user])

		# if user.save
			# login(user)
			# # flash[:message] = "#{user.username} created"
			# redirect "/admin"
		# else
			# flash[:message] = error_messages(user).join("<br>")
			# redirect '/signup'
		# end
	end


	# login routes ################################################
	get '/login' do
		# test
		"hello world from login route of users_controller"

		# redirect "/admin" if logged_in?
		# erb :"users/login"
	end

	post '/login' do
		# if params[:user][:username] == "" || params[:user][:password] == ""            
			# # flash[:message] = "Operation Failed <br> Both Username and Password must be filled out"
			# redirect '/login'
	        # else
			# user = User.find_by(username: params[:user][:username])
			# login(user)
			# # flash[:message] = "Welcome, #{user.first_name.capitalize}"
			# redirect "/admin"
		# end
	end


	# update routes ###############################
	get '/users/:slug/edit' do
		# test
		"hello world from edit route of users_controller"

		# redirect "/admin" if !logged_in?
		# erb :"/users/edit"
	end
    
	patch '/users/:slug' do
		# user = current_user
        
		# if user.update(params[:user])
			# # flash[:message] = "#{user.username} updated"
			# redirect "/users/#{user.slug}"
		# else
			# # flash[:message] = error_messages(user).join("<br>")
			# redirect "/users/#{current_user.slug}/edit"
		# end
	end

    
	# logout routes ################################################
	get '/logout' do
		# test
		"hello world from logout route of users_controller"

		# redirect '/' if !logged_in?
		# session.delete(:user_id)
		# redirect '/'
	end
end