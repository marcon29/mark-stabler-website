# require 'rack-flash'

class SocialPlatformslController < AppController
    # use Rack::Flash
    
    # create routes ###############################
	get '/social-platforms/new' do        
		redirect "/admin" if !logged_in?				
        erb :"/social_platforms/new"
	end

	post '/social-platforms' do
		platform = SocialPlatform.new(params[:social_platform])

		if platform.save
			# flash[:message] = "#{platform.name} created"
			redirect "/admin/social"
		else
			# flash[:message] = error_messages(social_platform).join("<br>")
			redirect back
		end
	end


	# update routes ###############################
    get '/social-platforms/:slug/edit' do		
		redirect "/admin" if !logged_in?
		@platform = SocialPlatform.find_by_slug(params[:slug])
		erb :"/social_platforms/edit"
	end
  
	patch '/social-platforms/:slug' do
		platform = SocialPlatform.find_by_slug(params[:slug])

		if platform.update(params[:social_platform])
			# flash[:message] = "#{platform.name} updated"
			redirect "/admin/social"
		else
			# flash[:message] = error_messages(social_platform).join("<br>")
			redirect back
		end
	end	
	

	# delete routes ###############################
	delete '/social-platforms/:slug' do
		platform = SocialPlatform.find_by_slug(params[:slug])
		platform.destroy
		# flash[:message] = "#{platform.name} removed"
		redirect "/admin/social"
	end
end
