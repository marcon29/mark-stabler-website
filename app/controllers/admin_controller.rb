# require 'rack-flash'

class AdminController < AppController
    # use Rack::Flash

    # admin home page ###############################################
	# this route for CMS home - don't need this if redirecting to a content page for web app
	# make this the login/signup home page if not logged in (users/index)
	# make gateway to all other functionality if logged in (users/admin)
	get '/admin' do
        # serves as login page when not logged in
        # serves as admin home page when logged in
        # links to home pages for each model
            # link to admin/users (erb: users/index)
            # link to admin/content (erb: content/index)
            # link to admin/social (erb: profiles/index)		
        
        # erb :"/admin/login" !logged_in?        
        # erb :"/admin"
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
		# erb :"users/index"
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

	get '/logout' do
		# redirect '/' if !logged_in?
		# session.delete(:user_id)
		# redirect "/admin"
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

		# erb :"/content_sections/index"
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
		
		# erb :"/social_profiles/index"
    end
    
    # no show route
        # all details will be on index page (admin/social)
end