# require 'rack-flash'

class SocialProfileslController < AppController
    # use Rack::Flash
    
    # create routes ###############################
	get '/social-profiles/new' do
		# form needs to also have ability associate to platform (existing only)
        
		# redirect "/admin" if !logged_in?				
        # erb :"/social_profiles/new"
	end

	post '/social-profiles' do
		# profile = SocialProfile.new(params[:social_profile])

		# if profile.save
			# # flash[:message] = "#{profile.name} created"
			# redirect "/admin/social"
		# else
			# # flash[:message] = error_messages(social_profile).join("<br>")
			# redirect back
		# end
	end


	# update routes ###############################
    get '/social-profiles/:slug/edit' do
		# form needs to also have ability associate to different platform (existing only)
		
		# redirect "/admin" if !logged_in?
		# profile = SocialProfile.find_by_slug(params[:slug])
		# erb :"/social_profiles/edit"
	end
  
	patch '/social-profiles/:slug' do
		# profile = SocialProfile.find_by_slug(params[:slug])

		# if profile.update(params[:social_profile])
			# # flash[:message] = "#{profile.name} updated"
			# redirect "/admin/social"
		# else
			# # flash[:message] = error_messages(social_profile).join("<br>")
			# redirect back
		# end
	end
	

	# delete routes ###############################
	delete '/social-profiles/:slug' do
		# profile = SocialProfile.find_by_slug(params[:slug])
		# profile.destroy
		# # flash[:message] = "#{profile.name} removed"
		# redirect "/admin/social"
	end
end
