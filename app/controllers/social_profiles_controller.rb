# require 'rack-flash'

class SocialProfileslController < AppController
    # use Rack::Flash
    
    # create routes ###############################
	get '/admin/social-profiles/new' do
		redirect "/admin" if !logged_in?
		@platforms = SocialPlatform.all
        erb :"social_profiles/new"
	end

	post '/social-profiles' do
		profile = SocialProfile.new(params[:social_profile])

		if profile.save
			# flash[:message] = "#{profile.name} created"
			redirect "/admin/social"
		else
			# flash[:message] = error_messages(social_profile).join("<br>")
			redirect back
		end
	end


	# update routes ###############################
    get '/admin/social-profiles/:slug/edit' do
		redirect "/admin" if !logged_in?		
		@profile = SocialProfile.find_by_slug(params[:slug])
		@platforms = SocialPlatform.all
		erb :"social_profiles/edit"
	end
  
	patch '/admin/social-profiles/:slug' do
		profile = SocialProfile.find_by_slug(params[:slug])

		if profile.update(params[:social_profile])
			# flash[:message] = "#{profile.name} updated"
			redirect "/admin/social"
		else
			# flash[:message] = error_messages(social_profile).join("<br>")
			redirect back
		end
	end
	

	# delete routes ###############################
	delete '/admin/social-profiles/:slug' do
		profile = SocialProfile.find_by_slug(params[:slug])
		profile.destroy
		# flash[:message] = "#{profile.name} removed"
		redirect "/admin/social"
	end
end
