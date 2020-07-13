# require 'rack-flash'

class SocialProfileslController < AppController
    # use Rack::Flash
    
    # create routes ###############################
    get '/social-profiles/new' do
        # test
        "hello world from new route of social_profile_controller"
        
        # redirect '/' if !logged_in?
        # insert code for action here
        # erb :"/social-profiles/new"
	end

	post '/social-profiles' do
		# insert code for action here
		# redirect "/social-profiles/#{social_profile.slug}"
	end

	# read routes #################################
	get '/social-profiles' do
		# test
		"hello world from index route of social_profile_controller"

		# redirect '/' if !logged_in?
		# insert code for action here
		# erb :"/social-profiles/index"
	end

    get '/social-profiles/:slug' do
        # test
        "hello world from show route of social_profile_controller"
        
		# redirect '/' if !logged_in?
		# insert code for action here
		# erb :"/social-profiles/show"
	end
  
	# update routes ###############################
    get '/social-profiles/:slug/edit' do
        # test
        "hello world from edit route of social_profile_controller"

		# redirect '/' if !logged_in?
		# insert code for action here
		# erb :"/social-profiles/edit"
	end
  
	patch '/social-profiles/:slug' do
		# insert code for action here
		# redirect "/social-profiles/#{social_profile.slug}"
	end
        
	# delete routes ###############################
	delete '/social-profiles/:slug' do
		# insert code for action here
		# redirect "/"
	end


end
