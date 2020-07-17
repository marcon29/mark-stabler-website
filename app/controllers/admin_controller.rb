# require 'rack-flash'

class AdminController < AppController
    # use Rack::Flash

    # admin home page ###############################################
	get '/admin' do
		@added_styles = ["admin.css"]
		if !logged_in?
			erb :"admin/login"
		else
			erb :"admin/index"			
		end
    end

    post '/admin/login' do
		# if params[:user][:username] == "" || params[:user][:password] == ""            
			# # flash[:message] = "Operation Failed <br> Both Username and Password must be filled out"
        # else
			# user = User.find_by(username: params[:user][:username])
			# login(user)
			# # flash[:message] = "Welcome, #{user.first_name.capitalize}"
		# end
		
		# remove these two and use above when adding flash messages		
		user = User.find_by(username: params[:user][:username])
		login(user)		
		redirect "/admin"
    end    

	get '/admin/logout' do
		logout! if logged_in?			
		redirect "/admin"
    end

    
    # admin/user routes ################################################
    get '/admin/users' do		
		redirect "/admin" if !logged_in?
		@users = User.all
		erb :"admin/users"
	end
	

    # admin/content routes ################################################
    get '/admin/content' do
		redirect "/admin" if !logged_in?
		@sections = ContentSection.all
		erb :"admin/content"
	end
	

    # admin/social routes ################################################
    get '/admin/social' do
		redirect "/admin" if !logged_in?
		@platforms = SocialPlatform.all
		@profiles = SocialProfile.all
		erb :"admin/social"
    end
end