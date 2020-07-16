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
		@user = User.create(user_info)
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
			visit "/users/#{@user.username}/edit"
			
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
				expect(page).to have_field(:first_name)
				expect(page).to have_field(:last_name)
				expect(page).to have_field(:email)
				expect(page).to have_field(:username)
				expect(page).to have_field(:password)
			end		
			
			it "POST users/new route lets a user enter info to create a new user then loads admin/users page upon success" do
				new_user_info = {first_name: "new", last_name: "usertest", email: "newusertest1@example.com", username: "newusertest1", password: "test"}
				visit '/users/new'

				fill_in :first_name, :with => "#{new_user_info[:first_name]}"
				fill_in :last_name, :with => "#{new_user_info[:last_name]}"
				fill_in :email, :with => "#{new_user_info[:email]}"
				fill_in :username, :with => "#{new_user_info[:username]}"
				fill_in :password, :with => "#{new_user_info[:password]}"
				click_button "Add User"

				# check user created correctly
				test_user = User.all.last
				expect(test_user.first_name).to eq(new_user_info[:first_name])
				expect(test_user.last_name).to eq(new_user_info[:last_name])
				expect(test_user.email).to eq(new_user_info[:email])
				expect(test_user.username).to eq(new_user_info[:username])
				expect(!!test_user.authenticate("#{new_user_info[:password]}")).to be true

				# check redirect (these should be good)
				expect(page.body).to include("<h1>User Management</h1>")
				expect(page.body).to include('<nav id="admin">')
				expect(page.body).to include('<a href="/users/new"')
			end
		end

		describe "won't create user if validated fields are blank" do
			it "POST users/new route won't create a new user if first_name field is left blank" do
				new_user_info = {first_name: "new", last_name: "usertest", email: "newusertest1@example.com", username: "newusertest1", password: "test"}
				visit '/users/new'
				total_users = User.all.count
				
				# fill in form without first_name
				fill_in :first_name, :with => ""
				fill_in :last_name, :with => "#{new_user_info[:last_name]}"
				fill_in :email, :with => "#{new_user_info[:email]}"
				fill_in :username, :with => "#{new_user_info[:username]}"
				fill_in :password, :with => "#{new_user_info[:password]}"
				click_button "Add User"

				# expect User.all.count to be same
				expect(User.all.count).to eq total_users

				# expect info from users/new page after reload
				expect(page.body).to include("<h1>Add New User</h1>")
				expect(page.body).to include('<form id="new-user-form"')
				expect(page.body).to include('method="post" action="/users/new"')
			end

			it "POST users/new route won't create a new user if last_name field is left blank" do
				new_user_info = {first_name: "new", last_name: "usertest", email: "newusertest1@example.com", username: "newusertest1", password: "test"}
				visit '/users/new'
				total_users = User.all.count

				# fill in form without last_name
				fill_in :first_name, :with => "#{new_user_info[:first_name]}"
				fill_in :last_name, :with => ""
				fill_in :email, :with => "#{new_user_info[:email]}"
				fill_in :username, :with => "#{new_user_info[:username]}"
				fill_in :password, :with => "#{new_user_info[:password]}"
				click_button "Add User"

				# expect User.all.count to be same
				expect(User.all.count).to eq total_users

				# expect info from users/new page after reload
				expect(page.body).to include("<h1>Add New User</h1>")
				expect(page.body).to include('<form id="new-user-form"')
				expect(page.body).to include('method="post" action="/users/new"')
			end

			it "POST users/new route won't create a new user if email field is left blank" do
				new_user_info = {first_name: "new", last_name: "usertest", email: "newusertest1@example.com", username: "newusertest1", password: "test"}
				visit '/users/new'
				total_users = User.all.count

				# fill in form without email
				fill_in :first_name, :with => "#{new_user_info[:first_name]}"
				fill_in :last_name, :with => "#{new_user_info[:last_name]}"
				fill_in :email, :with => ""
				fill_in :username, :with => "#{new_user_info[:username]}"
				fill_in :password, :with => "#{new_user_info[:password]}"
				click_button "Add User"

				# expect User.all.count to be same
				expect(User.all.count).to eq total_users

				# expect info from users/new page after reload
				expect(page.body).to include("<h1>Add New User</h1>")
				expect(page.body).to include('<form id="new-user-form"')
				expect(page.body).to include('method="post" action="/users/new"')
			end
			
			it "POST users/new route won't create a new user if username field is left blank" do
				new_user_info = {first_name: "new", last_name: "usertest", email: "newusertest1@example.com", username: "newusertest1", password: "test"}
				visit '/users/new'
				total_users = User.all.count

				# fill in form without username
				fill_in :first_name, :with => "#{new_user_info[:first_name]}"
				fill_in :last_name, :with => "#{new_user_info[:last_name]}"
				fill_in :email, :with => "#{new_user_info[:email]}"
				fill_in :username, :with => ""
				fill_in :password, :with => "#{new_user_info[:password]}"
				click_button "Add User"

				# expect User.all.count to be same
				expect(User.all.count).to eq total_users

				# expect info from users/new page after reload
				expect(page.body).to include("<h1>Add New User</h1>")
				expect(page.body).to include('<form id="new-user-form"')
				expect(page.body).to include('method="post" action="/users/new"')
			end

			it "POST users/new route won't create a new user if password field is left blank" do
				new_user_info = {first_name: "new", last_name: "usertest", email: "newusertest1@example.com", username: "newusertest1", password: "test"}
				visit '/users/new'
				total_users = User.all.count

				# fill in form without password
				fill_in :first_name, :with => "#{new_user_info[:first_name]}"
				fill_in :last_name, :with => "#{new_user_info[:last_name]}"
				fill_in :email, :with => "#{new_user_info[:email]}"
				fill_in :username, :with => "#{new_user_info[:username]}"
				fill_in :password, :with => ""
				click_button "Add User"

				# expect User.all.count to be same
				expect(User.all.count).to eq total_users

				# expect info from users/new page after reload
				expect(page.body).to include("<h1>Add New User</h1>")
				expect(page.body).to include('<form id="new-user-form"')
				expect(page.body).to include('method="post" action="/users/new"')
			end
		end

		describe "won't create user if validated fields are bad" do
			it "POST users/new route won't create a new user if email is same as other user" do
				new_user_info = {first_name: "new", last_name: "usertest", email: "newusertest1@example.com", username: "newusertest1", password: "test"}
				visit '/users/new'
				total_users = User.all.count

				# fill in form with duplicated email
				fill_in :first_name, :with => "#{new_user_info[:first_name]}"
				fill_in :last_name, :with => "#{new_user_info[:last_name]}"
				fill_in :email, :with => "tester1@example.com"
				fill_in :username, :with => "#{new_user_info[:username]}"
				fill_in :password, :with => "#{new_user_info[:password]}"
				click_button "Add User"

				# expect User.all.count to be same
				expect(User.all.count).to eq total_users

				# expect info from users/new page after reload
				expect(page.body).to include("<h1>Add New User</h1>")
				expect(page.body).to include('<form id="new-user-form"')
				expect(page.body).to include('method="post" action="/users/new"')
			end

			it "POST users/new route won't create a new user if email doesn't match standard email format" do
				new_user_info = {first_name: "new", last_name: "usertest", email: "newusertest1@example.com", username: "newusertest1", password: "test"}
				visit '/users/new'
				total_users = User.all.count

				# fill in form with bad email
				fill_in :first_name, :with => "#{new_user_info[:first_name]}"
				fill_in :last_name, :with => "#{new_user_info[:last_name]}"
				fill_in :email, :with => "newusertest1example.com"
				fill_in :username, :with => "#{new_user_info[:username]}"
				fill_in :password, :with => "#{new_user_info[:password]}"
				click_button "Add User"

				# expect User.all.count to be same
				expect(User.all.count).to eq total_users

				# expect info from users/new page after reload
				expect(page.body).to include("<h1>Add New User</h1>")
				expect(page.body).to include('<form id="new-user-form"')
				expect(page.body).to include('method="post" action="/users/new"')
			end

			it "POST users/new route won't create a new user if username is same as other user" do
				new_user_info = {first_name: "new", last_name: "usertest", email: "newusertest1@example.com", username: "newusertest1", password: "test"}
				visit '/users/new'
				total_users = User.all.count

				# fill in form with duplicated username
				fill_in :first_name, :with => "#{new_user_info[:first_name]}"
				fill_in :last_name, :with => "#{new_user_info[:last_name]}"
				fill_in :email, :with => "#{new_user_info[:email]}"
				fill_in :username, :with => "testuser1"
				fill_in :password, :with => "#{new_user_info[:password]}"
				click_button "Add User"

				# expect User.all.count to be same
				expect(User.all.count).to eq total_users

				# expect info from users/new page after reload
				expect(page.body).to include("<h1>Add New User</h1>")
				expect(page.body).to include('<form id="new-user-form"')
				expect(page.body).to include('method="post" action="/users/new"')
			end

			it "POST users/new route won't create a new user if username contains non-letters or spaces" do
				new_user_info = {first_name: "new", last_name: "usertest", email: "newusertest1@example.com", username: "newusertest1", password: "test"}
				visit '/users/new'
				total_users = User.all.count

				# fill in form with bad username
				fill_in :first_name, :with => "#{new_user_info[:first_name]}"
				fill_in :last_name, :with => "#{new_user_info[:last_name]}"
				fill_in :email, :with => "#{new_user_info[:email]}"
				fill_in :username, :with => "new usertest1"
				fill_in :password, :with => "#{new_user_info[:password]}"
				click_button "Add User"

				# expect User.all.count to be same
				expect(User.all.count).to eq total_users

				# expect info from users/new page after reload
				expect(page.body).to include("<h1>Add New User</h1>")
				expect(page.body).to include('<form id="new-user-form"')
				expect(page.body).to include('method="post" action="/users/new"')
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
				visit "/users/#{@user.username}/edit"

				# check correct edit form is displayed
				expect(page.body).to include("<h1>Edit #{@user.username}</h1>")
				expect(page.body).to include('<form id="edit-user-form"')
				expect(page.body).to include('method="post" action="/users/testuser1"')
				expect(page.body).to include('name="_method" value="patch"')

				# check edit form fields are prefilled with correct existing object info
				expect(find_field("first_name").value).to eq("#{@user.first_name}")
				expect(find_field("last_name").value).to eq("#{@user.last_name}")
				expect(find_field("email").value).to eq("#{@user.email}")
				expect(find_field("username").value).to eq("#{@user.username}")
				expect(find_field("password").value).to eq("")
				expect(page.body).to include("(leave this blank if not changing your password)")
			end
			
			it "POST users/edit route lets a user enter info to update an existing user then loads admin/users page upon success" do
				update_user_info = {first_name: "update", last_name: "usertest", email: "updateusertest1@example.com", username: "updateusertest1", password: "test"}
				visit "/users/#{@user.username}/edit"
				
				fill_in :first_name, :with => "#{update_user_info[:first_name]}"
				fill_in :last_name, :with => "#{update_user_info[:last_name]}"
				fill_in :email, :with => "#{update_user_info[:email]}"
				fill_in :username, :with => "#{update_user_info[:username]}"
				fill_in :password, :with => "#{update_user_info[:password]}"
				click_button "Update User"

				# check user updated correctly
				test_user = User.find(@user.id)
				expect(test_user.first_name).to eq(update_user_info[:first_name])
				expect(test_user.last_name).to eq(update_user_info[:last_name])
				expect(test_user.email).to eq(update_user_info[:email])
				expect(test_user.username).to eq(update_user_info[:username])
				expect(!!test_user.authenticate("#{update_user_info[:password]}")).to be true

				# check redirect (these should be good)
				expect(page.body).to include("<h1>User Management</h1>")
				expect(page.body).to include('<nav id="admin">')
				expect(page.body).to include('<a href="/users/new"')
			end
		end

		describe "won't update user if validated fields are blank" do
			it "POST users/edit route won't update user if first_name field is left blank" do
				update_user_info = {first_name: "update", last_name: "usertest", email: "updateusertest1@example.com", username: "updateusertest1", password: "test"}
				visit "/users/#{@user.username}/edit"
				check = @user.first_name
				
				# fill in form without first_name
				fill_in :first_name, :with => ""
				fill_in :last_name, :with => "#{update_user_info[:last_name]}"
				fill_in :email, :with => "#{update_user_info[:email]}"
				fill_in :username, :with => "#{update_user_info[:username]}"
				fill_in :password, :with => "#{update_user_info[:password]}"
				click_button "Update User"

				# expect first_name to be unchanged
				test_user = User.find(@user.id)
				expect(test_user.first_name).to eq(check)

				# expect info from users/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_user.username}</h1>")
				expect(page.body).to include('<form id="edit-user-form"')
			end

			it "POST users/edit route won't update user if last_name field is left blank" do
				update_user_info = {first_name: "update", last_name: "usertest", email: "updateusertest1@example.com", username: "updateusertest1", password: "test"}
				visit "/users/#{@user.username}/edit"
				check = @user.last_name

				# fill in form without last_name
				fill_in :first_name, :with => "#{update_user_info[:first_name]}"
				fill_in :last_name, :with => ""
				fill_in :email, :with => "#{update_user_info[:email]}"
				fill_in :username, :with => "#{update_user_info[:username]}"
				fill_in :password, :with => "#{update_user_info[:password]}"
				click_button "Update User"

				# expect last_name to be unchanged
				test_user = User.find(@user.id)
				expect(test_user.last_name).to eq(check)

				# expect info from users/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_user.username}</h1>")
				expect(page.body).to include('<form id="edit-user-form"')
			end

			it "POST users/edit route won't update user if email field is left blank" do
				update_user_info = {first_name: "update", last_name: "usertest", email: "updateusertest1@example.com", username: "updateusertest1", password: "test"}
				visit "/users/#{@user.username}/edit"
				check = @user.email

				# fill in form without email
				fill_in :first_name, :with => "#{update_user_info[:first_name]}"
				fill_in :last_name, :with => "#{update_user_info[:last_name]}"
				fill_in :email, :with => ""
				fill_in :username, :with => "#{update_user_info[:username]}"
				fill_in :password, :with => "#{update_user_info[:password]}"
				click_button "Update User"
				
				# expect email to be unchanged
				test_user = User.find(@user.id)
				expect(test_user.email).to eq(check)
				
				# expect info from users/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_user.username}</h1>")
				expect(page.body).to include('<form id="edit-user-form"')
			end

			it "POST users/edit route won't update user if username field is left blank" do
				update_user_info = {first_name: "update", last_name: "usertest", email: "updateusertest1@example.com", username: "updateusertest1", password: "test"}
				visit "/users/#{@user.username}/edit"
				check = @user.username
				
				# fill in form without username
				fill_in :first_name, :with => "#{update_user_info[:first_name]}"
				fill_in :last_name, :with => "#{update_user_info[:last_name]}"
				fill_in :email, :with => "#{update_user_info[:email]}"
				fill_in :username, :with => ""
				fill_in :password, :with => "#{update_user_info[:password]}"
				click_button "Update User"
				
				# expect username to be unchanged
				test_user = User.find(@user.id)
				expect(test_user.username).to eq(check)
				
				# expect info from users/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_user.username}</h1>")
				expect(page.body).to include('<form id="edit-user-form"')
			end

			it "POST users/edit route won't update user if password field is left blank (redirects to admin/users instead)" do
				update_user_info = {first_name: "update", last_name: "usertest", email: "updateusertest1@example.com", username: "updateusertest1", password: "password"}
				visit "/users/#{@user.username}/edit"				
				check = "test"

				# fill in form without password
				fill_in :first_name, :with => "#{update_user_info[:first_name]}"
				fill_in :last_name, :with => "#{update_user_info[:last_name]}"
				fill_in :email, :with => "#{update_user_info[:email]}"
				fill_in :username, :with => "#{update_user_info[:username]}"
				fill_in :password, :with => ""
				click_button "Update User"
				
				# expect password to authenticate with old password
				test_user = User.find(@user.id)
				expect(!!test_user.authenticate(check)).to be true
				
				# expect info from admin/users page after reload
				expect(page.body).to include("<h1>User Management</h1>")
				expect(page.body).to include('<nav id="admin">')
				expect(page.body).to include('<a href="/users/new"')
			end
		end

		describe "won't update user if validated fields are bad" do
			it "POST users/edit route won't update user if email is same as other user" do
				user2_info = {first_name: "test2", last_name: "user2", email: "tester2@example.com", username: "testuser2", password: "test"}
				user2 = User.create(user2_info)
				update_user_info = {first_name: "update", last_name: "usertest", email: "updateusertest1@example.com", username: "updateusertest1", password: "test"}
				
				visit "/users/#{@user.username}/edit"
				check = @user.email

				# fill in form with duplicated email
				fill_in :first_name, :with => "#{update_user_info[:first_name]}"
				fill_in :last_name, :with => "#{update_user_info[:last_name]}"
				fill_in :email, :with => "tester2@example.com"
				fill_in :username, :with => "#{update_user_info[:username]}"
				fill_in :password, :with => "#{update_user_info[:password]}"
				click_button "Update User"

				# expect email to be unchanged
				test_user = User.find(@user.id)
				expect(test_user.email).to eq(check)
				
				# expect info from users/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_user.username}</h1>")
				expect(page.body).to include('<form id="edit-user-form"')
			end

			it "POST users/edit route won't update user if email doesn't match standard email format" do
				update_user_info = {first_name: "update", last_name: "usertest", email: "updateusertest1@example.com", username: "updateusertest1", password: "test"}
				visit "/users/#{@user.username}/edit"
				check = @user.email

				# fill in form with bad email
				fill_in :first_name, :with => "#{update_user_info[:first_name]}"
				fill_in :last_name, :with => "#{update_user_info[:last_name]}"
				fill_in :email, :with => "updateusertest1@example"
				fill_in :username, :with => "#{update_user_info[:username]}"
				fill_in :password, :with => "#{update_user_info[:password]}"
				click_button "Update User"

				# expect email to be unchanged
				test_user = User.find(@user.id)
				expect(test_user.email).to eq(check)
				
				# expect info from users/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_user.username}</h1>")
				expect(page.body).to include('<form id="edit-user-form"')
			end

			it "POST users/edit route won't update user if username is same as other user" do
				user2_info = {first_name: "test2", last_name: "user2", email: "tester2@example.com", username: "testuser2", password: "test"}
				user2 = User.create(user2_info)
				update_user_info = {first_name: "update", last_name: "usertest", email: "updateusertest1@example.com", username: "updateusertest1", password: "test"}
				
				visit "/users/#{@user.username}/edit"
				check = @user.username

				# fill in form with duplicated username
				fill_in :first_name, :with => "#{update_user_info[:first_name]}"
				fill_in :last_name, :with => "#{update_user_info[:last_name]}"
				fill_in :email, :with => "#{update_user_info[:email]}"
				fill_in :username, :with => "testuser2"
				fill_in :password, :with => "#{update_user_info[:password]}"
				click_button "Update User"

				# expect username to be unchanged
				test_user = User.find(@user.id)
				expect(test_user.username).to eq(check)
				
				# expect info from users/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_user.username}</h1>")
				expect(page.body).to include('<form id="edit-user-form"')
			end

			it "POST users/edit route won't update user if username contains non-letters or spaces" do
				update_user_info = {first_name: "update", last_name: "usertest", email: "updateusertest1@example.com", username: "updateusertest1", password: "test"}
				visit "/users/#{@user.username}/edit"
				check = @user.username

				# fill in form with bad username
				fill_in :first_name, :with => "#{update_user_info[:first_name]}"
				fill_in :last_name, :with => "#{update_user_info[:last_name]}"
				fill_in :email, :with => "#{update_user_info[:email]}"
				fill_in :username, :with => "updateu$ertest1"
				fill_in :password, :with => "#{update_user_info[:password]}"
				click_button "Update User"

				# expect username to be unchanged
				test_user = User.find(@user.id)
				expect(test_user.username).to eq(check)
				
				# expect info from users/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_user.username}</h1>")
				expect(page.body).to include('<form id="edit-user-form"')
			end
		end

		# it "POST Route displays the appropriate flash message upon redirect" do
		# 	# think I can test the display in only processing routes no in every get
		# 	# visit "/users/#{@user.username}/edit"
		# end
	end

	# delete user routes ###########################################################
	describe "delete user route" do
		before do
			visit_admin_and_login_user
		end

		it "DELETE users route deletes only the correct user then loads admin/users page upon success" do
			user2_info = {first_name: "test2", last_name: "user2", email: "tester2@example.com", username: "testuser2", password: "test"}
			user2 = User.create(user2_info)

			visit '/admin/users'
			click_button "delete-#{user2.username}"
			
			expect(User.all.include?(user2)).to be false
			expect(User.all.include?(@user)).to be true
			expect(page.body).to include("<h1>User Management</h1>")
			expect(page.body).to include('<nav id="admin">')
			expect(page.body).to include('<a href="/users/new"')
		end

		it "DELETE users route won't delete last remaining user, loads admin/users page upon failure" do
			visit '/admin/users'
			click_button "delete-#{@user.username}"
			
			expect(User.all.include?(@user)).to be true
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