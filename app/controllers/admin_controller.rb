# require 'rack-flash'

class AdminController < AppController
    # use Rack::Flash

    # admin home page ###############################################
	# this route for CMS home - don't need this if redirecting to a content page for web app
	# make this the login/signup home page if not logged in (users/index)
	# make gateway to all other functionality if logged in (users/admin)
	get '/admin' do
		if !logged_in?
			erb :"/admin/login"
		else
			erb :"/admin/index"			
		end
    end

    post '/login' do
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

	get '/logout' do
		logout! if logged_in?			
		redirect "/admin"
    end

    
    # admin/user routes ################################################
    # no login view route (login page view is on admin page if not logged in)

    get '/admin/users' do
        # ======================================================
        # lists all users and their info
        # for each user: 
            # link to users/slug/edit (erb: users/edit)            
            # link to delete (route only)
        # link to users/new (erb: users/new)
        # ======================================================
		
		# redirect "/admin" if !logged_in?
		# erb :"/admin/users"
    end

    # admin/content routes ################################################
    get '/admin/content' do
		# ======================================================
		# lists all content_section objects (in location order) and select info (name, HL, body, link text, last updated)
        # for each object:
            # link to content-sections/slug/edit (erb :content_sections/edit)
			# link to delete (route only)
		# link to content-sections/new (erb :content_sections/new)
		# ======================================================

		# redirect "/admin" if !logged_in?

		# insert code for action here

		# erb :"/admin/content"
	end

	# no show route
		# all important details will be on index page (admin/content)
		# rest only needed for editing, so only show on that page


    # admin/social routes ################################################
    get '/admin/social' do
		# ======================================================
		# lists all social_platforms objects with all info
        # for each platform:
            # link to social-platforms/slug/edit (erb :social_platforms/edit)
			# link to delete (route only)
		# link to social-platforms/new (erb :social_platforms/new)

		# lists all social_profiles objects with all info (by platform)
        # for each profile:
            # link to social-profiles/slug/edit (erb :social_profiles/edit)
			# link to delete (route only)
		# link to social-profiles/new (erb :social_profiles/new)
		# ======================================================

		# redirect "/admin" if !logged_in?

		# insert code for action here
		
		# erb :"/admin/social"
    end
    
    # no show route
        # all details will be on index page (admin/social)
end