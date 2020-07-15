# require 'rack-flash'

class UsersController < AppController
	# use Rack::Flash
    
    # new user (signup) routes ################################################
    get '/users/new' do
        # redirect "/admin" if !logged_in?
		erb :"users/new"
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
	get '/users/:username/edit' do
        # redirect "/admin" if !logged_in?
        @user = User.find_by(username: params[:username])
		erb :"/users/edit"
	end
    
	patch '/users/:username' do
		# user = User.find_by(username: params[:username])
        
		# if user.update(params[:user])
			# # flash[:message] = "#{user.username} updated"
			# redirect "/admin/users"
		# else
			# # flash[:message] = error_messages(user).join("<br>")
			# redirect back
		# end
	end    

    
	# delete routes ###############################
	delete '/users/:username' do
		if User.all.count == 1
			# # flash[:message] = "You can't delete the only registered user."
		else
			# user = User.find_by(username: params[:username])
			# user.destroy
			# # flash[:message] = "#{user.username} removed"
		end
		redirect "/admin/users"		
	end
end