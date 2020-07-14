require 'spec_helper'

describe "UsersController" do
	
	# need a logged in user for all of these

	# before do
	# 	user_info = {
	# 		first_name: "test", 
	# 		last_name: "user", 
	# 		email: "tester1@example.com",
	# 		username: "testuser1", 
	# 		password: "test"
	# 	}
	# 	user = User.create(user_info)
		
	# 	visit_admin_and_login_user
	# end

	# after do
	# 	logout_user
	# end
	

	# controller tests ###########################################################
	describe "new user routes" do		
		it "GET Route redirects to the login page when user is not logged in" do			
			# visit '/users/new'

		end		
		
		it "GET Route loads the users/new page when the user is logged in and displays the new user form" do
			# visit '/users/new'
		end
    
        it "POST Route lets a user create a new user" do
			# visit '/users/new'
		end

		it "POST Route loads the admin/users page after creating a new user" do
			# visit '/users/new'
		end

		# it "POST Route displays the appropriate flash message upon redirect" do
		#	# think I can test the display in only processing routes no in every get
		# 	# visit '/users/new'
		# end
	end

	describe "update user routes" do
		it "GET Route redirects to the login page when user is not logged in" do
			# visit '/users/:slug/edit'
		end		
		
		it "GET Route loads the users/edit page when the user is logged in and displays the edit user form" do
			# make sure edit form has the correct existing object info
			# visit '/users/:slug/edit'
		end
    
        it "POST Route lets a user update an existing user" do
			# visit '/users/:slug/edit'
		end

		it "POST Route loads the admin/users page after updating an existing user" do
			# visit '/users/:slug/edit'
		end

		# it "POST Route displays the appropriate flash message upon redirect" do
		# 	# think I can test the display in only processing routes no in every get
		# 	# visit '/users/:slug/edit'
		# end
	end

	describe "delete user routes" do		
		it "deletes the user" do
			# visit '/admin/users'
		end		
		
		it "redirects to the admin/users page after deletion" do
			# visit '/admin/users'
		end

		# it "POST Route displays the appropriate flash message upon redirect" do
		# 	# think I can test the display in only processing routes no in every get
		# 	# visit '/admin/users'
		# end
	end


	# helper method tests ########################################################


end