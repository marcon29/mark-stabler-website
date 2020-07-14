# require 'rack-flash'

class ContentSectionslController < AppController
    # use Rack::Flash
    
    # create routes ###############################
    get '/content-sections/new' do
        # redirect "/admin" if !logged_in?
		# erb :"/content_sections/new"
	end

	post '/content-sections' do
		# con_sec = ContentSection.new(params[:content_section])

		# if con_sec.save
			# # flash[:message] = "#{con_sec.name} created"
			# redirect "/admin/content"
		# else
			# # flash[:message] = error_messages(content_section).join("<br>")
			# redirect back
		# end
	end


	# update routes ###############################
    get '/content-sections/:slug/edit' do
		# redirect "/admin" if !logged_in?
		# con_sec = ContentSection.find_by_slug(params[:slug])
		# erb :"/content_sections/edit"
	end
  
	patch '/content-sections/:slug' do
		# con_sec = ContentSection.find_by_slug(params[:slug])

		# if con_sec.update(params[:content_section])
			# # flash[:message] = "#{con_sec.name} updated"
			# redirect "/admin/content"
		# else
			# # flash[:message] = error_messages(content_section).join("<br>")
			# redirect back
		# end
	end


	# delete routes ###############################
	delete '/content-sections/:slug' do
		# con_sec = ContentSection.find_by_slug(params[:slug])
		# con_sec.destroy
		# # flash[:message] = "#{con_sec.name} removed"
		# redirect "/admin/content"
	end
end
