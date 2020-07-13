# require 'rack-flash'

class ContentSectionslController < AppController
    # use Rack::Flash
    
    # create routes ###############################
    get '/content-sections/new' do
        # test
        "hello world from new route of content_section_controller"
        
        # redirect '/' if !logged_in?
        # insert code for action here
        # erb :"/content-sections/new"
	end

	post '/content-sections' do
		# insert code for action here
		# redirect "/content-sections/#{content_section.slug}"
	end

	# read routes #################################
	get '/content-sections' do
		# test
		"hello world from index route of content_section_controller"

		# redirect '/' if !logged_in?
		# insert code for action here
		# erb :"/content-sections/index"
	end

    get '/content-sections/:slug' do
        # test
        "hello world from show route of content_section_controller"
        
		# redirect '/' if !logged_in?
		# insert code for action here
		# erb :"/content-sections/show"
	end
  
	# update routes ###############################
    get '/content-sections/:slug/edit' do
        # test
        "hello world from edit route of content_section_controller"

		# redirect '/' if !logged_in?
		# insert code for action here
		# erb :"/content-sections/edit"
	end
  
	patch '/content-sections/:slug' do
		# insert code for action here
		# redirect "/content-sections/#{content_section.slug}"
	end
        
	# delete routes ###############################
	delete '/content-sections/:slug' do
		# insert code for action here
		# redirect "/"
	end


end
