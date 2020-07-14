require 'spec_helper'

require 'pry'

describe "AdminController" do
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
	describe "no routes except admin/login allow access to non-signed-in users" do
		it "admin/users route redirects to the admin/login page if user not logged in" do
			visit '/admin/users'

			expect(page.body).to include("<h1>Login</h1>")
			expect(page.body).to include('<form id="login-form"')
			expect(page).to have_field(:username)
			expect(page).to have_field(:password)
		end

		it "admin/content route redirects to the admin/login page if user not logged in" do
			visit '/admin/content'

			expect(page.body).to include("<h1>Login</h1>")
			expect(page.body).to include('<form id="login-form"')
			expect(page).to have_field(:username)
			expect(page).to have_field(:password)
		end

		it "admin/social route redirects to the admin/login page if user not logged in" do
			visit '/admin/social'

			expect(page.body).to include("<h1>Login</h1>")
			expect(page.body).to include('<form id="login-form"')
			expect(page).to have_field(:username)
			expect(page).to have_field(:password)
		end
	end

	# # admin home tests ###########################################################
	# describe "Admin home routes" do
	# 	describe "admin route" do
	# 		it "loads the admin/login page and displays login form when user is not logged in" do
	# 			visit '/admin'				

	# 			expect(page.body).to include("<h1>Login</h1>")
	# 			expect(page.body).to include('<form id="login-form"')
	# 			expect(page).to have_field(:username)
	# 			expect(page).to have_field(:password)
	# 		end		
			
	# 		it "loads the admin/index page when user is logged in, which displays admin nav, links to main admin pages and to logout" do
	# 			visit '/admin'
	# 			login_user
				
	# 			expect(page.body).to include("<h1>Admin Home</h1>")
	# 			expect(page.body).to include('<nav id="admin">')
	# 			expect(page.body).to include('<a href="/admin/content"')
	# 			expect(page.body).to include('<a href="/admin/social"')
	# 			expect(page.body).to include('<a href="/admin/users"')
	# 			expect(page.body).to include('<a href="/logout"')
	# 		end
	# 	end
		
	# 	describe "POST login route" do
	# 		it "lets a user enter their login info, logs them in, then loads admin page after successful login" do
	# 			visit '/admin'
	# 			fill_in :username, :with => "testuser1"
	# 			fill_in :password, :with => "test"
	# 			click_button "Log In"
				
	# 			expect(page.body).to include("<h1>Admin Home</h1>")
	# 		end

	# 		it "won't let an unregistered user log in" do
	# 			visit '/admin'
	# 			fill_in :username, :with => "baduser1"
	# 			fill_in :password, :with => "test"
	# 			click_button "Log In"
								
	# 			expect(page.body).to include("<h1>Login</h1>")
	# 		end

	# 		it "won't let a registered user log in with wrong password" do
	# 			visit '/admin'
	# 			fill_in :username, :with => "testuser1"
	# 			fill_in :password, :with => "badpassword"
	# 			click_button "Log In"
								
	# 			expect(page.body).to include("<h1>Login</h1>")
	# 		end

	# 		it "won't log a user in if username field is left blank" do
	# 			visit '/admin'
	# 			fill_in :username, :with => ""
	# 			fill_in :password, :with => "test"
	# 			click_button "Log In"

	# 			expect(page.body).to include("<h1>Login</h1>")
	# 		end

	# 		it "won't log a user in if password field is left blank" do
	# 			visit '/admin'
	# 			fill_in :username, :with => "testuser1"
	# 			fill_in :password, :with => ""
	# 			click_button "Log In"
				
	# 			expect(page.body).to include("<h1>Login</h1>")
	# 		end

	# 		# it "POST Route displays the appropriate flash message upon redirect" do
	# 		#	# think I can test the display in only processing routes no in every get
	# 		# 	visit '/admin'
	# 		# end
	# 	end

	# 	describe "GET logout route" do
	# 		it "logs a user out then redirects to the admin page" do
	# 			visit_admin_and_login_user
	# 			click_link "Log Out"

	# 			expect(page.body).to include("<h1>Login</h1>")
	# 		end

	# 		# it "displays the appropriate flash message upon redirect" do
	# 		#	# think I can test the display in only processing routes no in every get
	# 		# 	visit '/admin'
	# 		# end
	# 	end
	# end
	
	# admin user tests ###########################################################
	describe "Admin User Routes" do
		before do
			visit_admin_and_login_user
		end

		it "loads the admin/users page only if a user is logged in" do		
			visit '/admin/users'
			
			expect(page.body).to include("<h1>User Management</h1>")
			expect(page.body).to include('<nav id="admin">')
			expect(page.body).to include('<a href="/users/new"')
		end
		
		it "admin/users page lists all users and for each one shows their info and edit and delete buttons" do
			user2_info = {first_name: "test2", last_name: "user2", email: "tester2@example.com",username: "testuser2", password: "test"}
			user3_info = {first_name: "test3", last_name: "user3", email: "tester3@example.com",username: "testuser3", password: "test"}
			user4_info = {first_name: "test4", last_name: "user4", email: "tester4@example.com",username: "testuser4", password: "test"}
			User.create(user2_info)
			User.create(user3_info)
			User.create(user4_info)

			visit '/admin/users'

			User.all.each do |user|				
				expect(page.body).to include(user.username)
				expect(page.body).to include(user.full_name)
				expect(page.body).to include(user.email)
				expect(page.body).to include("/users/#{user.username}/edit")
				expect(page.body).to include("/users/#{user.username}")
			end
		end
	end
	
	# # admin content tests ###########################################################
	# describe "Admin Content routes" do
	# 	before do
	# 		visit_admin_and_login_user
	# 	end

	# 	it "loads the admin/content page only if a user is logged in" do			
	# 		visit '/admin/content'
			
	# 		expect(page.body).to include("<h1>Content Management</h1>")
	# 		expect(page.body).to include('<nav id="admin">')
	# 		expect(page.body).to include('<a href="/content-sections/new"')
	# 	end
		
	# # 	it "admin/content page lists all content_sections in location order" do
	# # 		visit '/admin/content'

	# #			action="/content-sections/<%= s.slug %>/edit"
	# #			action="/content-sections/<%= s.slug %>"
	# # 	end

	# # 	it "each content_section on admin/content page displays its name, HL, body, link text, last updated" do
	# # 		visit '/admin/content'
	# # 	end

	# 	it "each content_section on admin/content page has buttons to edit and delete it" do
	# 		visit '/admin/content'

	# 		expect(page.body).to include('<input type="submit" value="Edit Content Section">')
	# 		expect(page.body).to include('<input type="submit" value="Delete Content Section">')
	# 	end
	# end
	
	# # admin social tests ###########################################################
	# describe "Admin Social routes" do
	# 	before do
	# 		visit_admin_and_login_user
	# 	end

	# 	it "loads the admin/social page only if a user is logged in" do			
	# 		visit '/admin/social'
			
	# 		expect(page.body).to include("<h1>Social Management</h1>")
	# 		expect(page.body).to include('<nav id="admin">')
	# 		expect(page.body).to include('<a href="/social-platforms/new"')
	# 		expect(page.body).to include('<a href="/social-profiles/new"')
	# 	end
		
	# 	# it "admin/social page lists all social_platforms and their info" do
	# 	# 	visit '/admin/social'
	# 	# end

	# 	it "each social_platform on admin/social page has buttons to edit and delete it" do
	# 		visit '/admin/social'

	# 		expect(page.body).to include('<input type="submit" value="Edit Platform">')
	# 		expect(page.body).to include('<input type="submit" value="Delete Platform">')
	# 	end

	# 	# # profile portion tests #########		
	# 	# it "admin/social page lists all social_profiles and their info" do
	# 	# 	visit '/admin/social'
	# 	# end

	# 	it "each social_profile on admin/social page has buttons to edit and delete it" do
	# 		visit '/admin/social'

	# 		expect(page.body).to include('<input type="submit" value="Edit Profile">')
	# 		expect(page.body).to include('<input type="submit" value="Delete Profile">')
	# 	end
    # end
end