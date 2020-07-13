# require 'rack-flash'

class SocialPlatformslController < AppController
    # use Rack::Flash
    
    # create routes ###############################
    get '/social-platforms/new' do
        # test
        "hello world from new route of social_platform_controller"
        
        # redirect '/' if !logged_in?
        # insert code for action here
        # erb :"/social-platforms/new"
	end

	post '/social-platforms' do
		# insert code for action here
		# redirect "/social-platforms/#{social_platform.slug}"
	end

	# read routes #################################
	get '/social-platforms' do
		# test
		"hello world from index route of social_platform_controller"

		# redirect '/' if !logged_in?
		# insert code for action here
		# erb :"/social-platforms/index"
	end

    get '/social-platforms/:slug' do
        # test
        "hello world from show route of social_platform_controller"
        
		# redirect '/' if !logged_in?
		# insert code for action here
		# erb :"/social-platforms/show"
	end
  
	# update routes ###############################
    get '/social-platforms/:slug/edit' do
        # test
        "hello world from edit route of social_platform_controller"

		# redirect '/' if !logged_in?
		# insert code for action here
		# erb :"/social-platforms/edit"
	end
  
	patch '/social-platforms/:slug' do
		# insert code for action here
		# redirect "/social-platforms/#{social_platform.slug}"
	end
        
	# delete routes ###############################
	delete '/social-platforms/:slug' do
		# insert code for action here
		# redirect "/"
	end


end
