# require 'rack-flash'

class UsersController < AppController
	# use Rack::Flash
    
    # new user (signup) routes ################################################
    get '/users/new' do
        # redirect "/admin" if !logged_in?
		# erb :"users/new"
	end
    
    post '/users/new' do
        # don't login after creation, only an existing user can create a new one

		# user = User.new(params[:user])

		# if user.save
			# # flash[:message] = "#{user.username} created"
			# redirect "/admin/users"
		# else
			# # flash[:message] = error_messages(user).join("<br>")
			# redirect back
		# end
    end    


	# update routes ###############################
	get '/users/:slug/edit' do
        # redirect "/admin" if !logged_in?
        # user = User.find_by_slug(params[:slug])
		# erb :"/users/edit"
	end
    
	patch '/users/:slug' do
		# user = User.find_by_slug(params[:slug])
        
		# if user.update(params[:user])
			# # flash[:message] = "#{user.username} updated"
			# redirect "/admin/users"
		# else
			# # flash[:message] = error_messages(user).join("<br>")
			# redirect back
		# end
	end    

    
    # delete routes ###############################
	delete '/users/:slug' do
		# user = User.find_by_slug(params[:slug])
		# user.destroy
		# # flash[:message] = "#{user.username} removed"
		# redirect "/admin/users"
	end
end