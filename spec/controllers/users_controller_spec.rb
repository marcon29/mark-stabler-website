require 'spec_helper'

describe "UsersController" do
	before do
		user_info = {
			first_name: "test", 
			last_name: "user", 
			email: "tester1@example.com",
			username: "testuser1", 
			password: "test"
		}
		user = User.create(user_info)
	end
	
	# non-user blocked access tests ###########################################################
	describe "no routes allow access to non-signed-in users" do
		it "GET users/new route redirects to the admin/login page if user not logged in" do
			visit '/users/new'

			expect(page.body).to include("<h1>Login</h1>")
			expect(page.body).to include('<form id="login-form"')
			expect(page.body).to include('method="post" action="/login"')
			expect(page).to have_field(:username)
			expect(page).to have_field(:password)
		end

		it "GET users/edit route redirects to the admin/login page if user not logged in" do
			visit '/users/:slug/edit'
			
			expect(page.body).to include("<h1>Login</h1>")
			expect(page.body).to include('<form id="login-form"')
			expect(page.body).to include('method="post" action="/login"')
			expect(page).to have_field(:username)
			expect(page).to have_field(:password)
		end
	end

	# new user routes ###########################################################
	describe "new user routes" do
		before do
			visit_admin_and_login_user
		end

		describe "displays and lets user interact with new user form" do
			it "GET users/new route loads the users/new page and displays new user form when user is logged in" do
				visit '/users/new'

				expect(page.body).to include("<h1>Add New User</h1>")
				expect(page.body).to include('<form id="new-user-form"')
				expect(page.body).to include('method="post" action="/users/new"')
				# expect(page).to have_field(:first_name)
				# expect(page).to have_field(:last_name)
				# expect(page).to have_field(:email)
				# expect(page).to have_field(:username)
				# expect(page).to have_field(:password)
			end		
			
			it "POST users/new route lets a user enter info to create a new user then loads admin/users page upon success" do
				visit '/users/new'

				# fill in form with new first_name
				# fill in form with new last_name
				# fill in form with new email
				# fill in form with new username
				# fill in form with new password
				# click_button "Add User"

					# check user created correctly
				# expect first_name to eq new first_name
				# expect last_name to eq new last_name
				# expect email to eq new email
				# expect username to eq new username
				# expect password to eq new password			

					# check redirect
				expect(page.body).to include("<h1>User Management</h1>")
				expect(page.body).to include('<nav id="admin">')
				expect(page.body).to include('<a href="/users/new"')
			end
		end

		describe "won't create user if validated fields are blank" do
			# need to split this up
			it "POST users/new route won't create a new user if first_name field is left blank" do
				# it "POST users/new route won't create a new user if last_name field is left blank" do
				# it "POST users/new route won't create a new user if email field is left blank" do
				# it "POST users/new route won't create a new user if username field is left blank" do
				# it "POST users/new route won't create a new user if password field is left blank" do

				# visit '/users/new'
				# get User.all.count
				# fill in form without first_name
				# click_button "Add User"
				# expect User.all.count to be same
				# expect info from users/new page after reload
				# end

				# visit '/users/new'
				# get User.all.count
				# fill in form without last_name
				# click_button "Add User"
				# expect User.all.count to be same
				# expect info from users/new page after reload
				# end

				# visit '/users/new'
				# get User.all.count
				# fill in form without email
				# click_button "Add User"
				# expect User.all.count to be same
				# expect info from users/new page after reload
				# end
							
				# visit '/users/new'
				# get User.all.count
				# fill in form without username
				# click_button "Add User"
				# expect User.all.count to be same
				# expect info from users/new page after reload
				# end

				# visit '/users/new'
				# get User.all.count
				# fill in form without password
				# click_button "Add User"
				# expect User.all.count to be same
				# expect info from users/new page after reload
				# end
			end
		end

		describe "won't create user if validated fields are bad" do
			it "POST users/new route won't create a new user if email is same as other user" do
				visit '/users/new'

				# get User.all.count
				# fill in form with duplicated email
				# click_button "Add User"

				# expect User.all.count to be same
				# expect info from users/new page after reload
			end

			it "POST users/new route won't create a new user if email doesn't match standard email format" do
				visit '/users/new'

				# get User.all.count
				# fill in form with bad email
				# click_button "Add User"

				# expect User.all.count to be same
				# expect info from users/new page after reload
			end

			it "POST users/new route won't create a new user if username is same as other user" do
				visit '/users/new'

				# get User.all.count
				# fill in form with duplicated username
				# click_button "Add User"

				# expect User.all.count to be same
				# expect info from users/new page after reload
			end

			it "POST users/new route won't create a new user if username contains non-letters or spaces" do
				# visit '/users/new'

				# get User.all.count
				# fill in form with bad username
				# click_button "Add User"

				# expect User.all.count to be same
				# expect info from users/new page after reload
			end
		end

		# it "POST Route displays the appropriate flash message upon redirect" do
		#	# think I can test the display in only processing routes no in every get
		# 	# visit '/users/new'
		# end
	end

	# update user routes ###########################################################
	describe "update user routes" do
		before do
			visit_admin_and_login_user
		end

		describe "displays and lets user interact with edit user form" do
			it "GET users/edit route loads the users/edit page and displays edit user form when user is logged in " do			
				visit '/users/:slug/edit'

					# check correct edit form is displayed
				expect(page.body).to include("<h1>Edit #{user.username}</h1>")
				expect(page.body).to include('<form id="user-edit-form"')
				expect(page.body).to include('method="post" action="/users/#{user.slug}"')
				expect(page.body).to include('name="_method" value="patch"')
				# expect(page).to have_field(:username)
				# expect(page).to have_field(:password)

					# check edit form has the correct existing object info
				# expect first_name field to be populated with user.first_name
				# expect last_name field to be populated with user.last_name
				# expect email field to be populated with user.email
				# expect username field to be populated with user.username
				# expect password field to be populated with user.password
			end
			
			it "POST users/edit route lets a user enter info to update an existing user then loads admin/users page upon success" do
				visit '/users/:slug/edit'

				# fill in form with new first_name
				# fill in form with new last_name
				# fill in form with new email
				# fill in form with new username
				# fill in form with new password
				# click_button "Update User"

					# check user updated correctly
				# expect first_name to eq new first_name
				# expect last_name to eq new last_name
				# expect email to eq new email
				# expect username to eq new username
				# expect password to eq new password			

					# check redirect
				expect(page.body).to include("<h1>User Management</h1>")
				expect(page.body).to include('<nav id="admin">')
				expect(page.body).to include('<a href="/users/new"')
			end
		end

		describe "won't update user if validated fields are blank" do
			# need to split this up
			it "POST users/edit route won't update user if first_name field is left blank" do
				# it "POST users/edit route won't update user if last_name field is left blank" do
				# it "POST users/edit route won't update user if email field is left blank" do
				# it "POST users/edit route won't update user if username field is left blank" do
				# it "POST users/edit route won't update user if password field is left blank" do

				# visit '/users/:slug/edit'
				# fill in form without first_name
				# click_button "Update User"
				# expect first_name to be unchanged
				# expect info from users/edit page after reload
				# end

				# visit '/users/:slug/edit'
				# fill in form without last_name
				# click_button "Update User"
				# expect last_name to be unchanged
				# expect info from users/edit page after reload
				# end

				# visit '/users/:slug/edit'
				# fill in form without email
				# click_button "Update User"
				# expect email to be unchanged
				# expect info from users/edit page after reload
				# end

				# visit '/users/:slug/edit'
				# fill in form without username
				# click_button "Update User"
				# expect username to be unchanged
				# expect info from users/edit page after reload
				# end
				
				# visit '/users/:slug/edit'			
				# fill in form without password
				# click_button "Update User"
				# expect password to be unchanged			
				# expect info from users/edit page after reload
				# end
			end
		end

		describe "won't update user if validated fields are bad" do
			it "POST users/edit route won't update user if email is same as other user" do
				visit '/users/:slug/edit'

				# fill in form with duplicated email
				# click_button "Update User"

				# expect email to be unchanged
				# expect info from users/edit page after reload
			end

			it "POST users/edit route won't update user if email doesn't match standard email format" do
				visit '/users/:slug/edit'

				# fill in form with bad email
				# click_button "Update User"

				# expect email to be unchanged
				# expect info from users/edit page after reload
			end

			it "POST users/edit route won't update user if username is same as other user" do
				visit '/users/:slug/edit'

				# fill in form with duplicated username
				# click_button "Update User"

				# expect username to be unchanged
				# expect info from users/edit page after reload
			end

			it "POST users/edit route won't update user if username contains non-letters or spaces" do
				visit '/users/:slug/edit'

				# fill in form with bad username
				# click_button "Update User"

				# expect username to be unchanged
				# expect info from users/edit page after reload
			end
		end

		# it "POST Route displays the appropriate flash message upon redirect" do
		# 	# think I can test the display in only processing routes no in every get
		# 	# visit '/users/:slug/edit'
		# end
	end

	# delete user routes ###########################################################
	describe "delete user route" do
		before do
			visit_admin_and_login_user
		end

		it "DELETE users route deletes only the correct user then loads admin/users page upon success" do
			# create a 2nd user

			visit '/admin/users'

			# click delete button for user

			# expect User.all to not include deleted user

			expect(page.body).to include("<h1>User Management</h1>")
			expect(page.body).to include('<nav id="admin">')
			expect(page.body).to include('<a href="/users/new"')			
		end

		it "DELETE users route won't delete last remaining user, loads admin/users page upon failure" do
			visit '/admin/users'
			
			# click delete button for user
			
			# expect User.all to include deleted user

			expect(page.body).to include("<h1>User Management</h1>")
			expect(page.body).to include('<nav id="admin">')
			expect(page.body).to include('<a href="/users/new"')			
		end

		# it "POST Route displays the appropriate flash message upon redirect" do
		# 	# think I can test the display in only processing routes no in every get
		# 	# visit '/admin/users'
		# end
	end
end