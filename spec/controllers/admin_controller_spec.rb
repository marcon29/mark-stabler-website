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

	# admin home tests ###########################################################
	describe "Admin home routes" do
		describe "admin route" do
			it "loads the login page and displays login form when user is not logged in" do
				visit '/admin'				

				expect(page.body).to include("<h2>Login</h2>")
				expect(page.body).to include('<form id="login-form"')
				expect(page).to have_field(:username)
				expect(page).to have_field(:password)
			end		
			
			it "loads the admin/index page when user is logged in, which displays admin nav, links to main admin pages and to logout" do
				visit '/admin'
				login_user
				
				expect(page.body).to include("<h2>Admin Home</h2>")
				expect(page.body).to include('<nav id="admin">')
				expect(page.body).to include('<a href="/admin/content"')
				expect(page.body).to include('<a href="/admin/social"')
				expect(page.body).to include('<a href="/admin/users"')
				expect(page.body).to include('<a href="/logout"')
			end
		end
		
		describe "POST login route" do
			it "lets a user enter their login info, logs them in, then loads admin page after successful login" do
				visit '/admin'
				fill_in :username, :with => "testuser1"
				fill_in :password, :with => "test"
				click_button "Log In"
				
				expect(page.body).to include("<h2>Admin Home</h2>")
			end

			it "won't let an unregistered user log in" do
				visit '/admin'
				fill_in :username, :with => "baduser1"
				fill_in :password, :with => "test"
				click_button "Log In"
								
				expect(page.body).to include("<h2>Login</h2>")
			end

			it "won't let a registered user log in with wrong password" do
				visit '/admin'
				fill_in :username, :with => "testuser1"
				fill_in :password, :with => "badpassword"
				click_button "Log In"
								
				expect(page.body).to include("<h2>Login</h2>")
			end

			it "won't log a user in if username field is left blank" do
				visit '/admin'
				fill_in :username, :with => ""
				fill_in :password, :with => "test"
				click_button "Log In"

				expect(page.body).to include("<h2>Login</h2>")
			end

			it "won't log a user in if password field is left blank" do
				visit '/admin'
				fill_in :username, :with => "testuser1"
				fill_in :password, :with => ""
				click_button "Log In"
				
				expect(page.body).to include("<h2>Login</h2>")
			end

			# it "POST Route displays the appropriate flash message upon redirect" do
			#	# think I can test the display in only processing routes no in every get
			# 	visit '/admin'
			# end
		end

		describe "GET logout route" do
			it "logs a user out then redirects to the admin page" do
				visit_admin_and_login_user
				click_link "Log Out"

				expect(page.body).to include("<h2>Login</h2>")
			end

			# it "displays the appropriate flash message upon redirect" do
			#	# think I can test the display in only processing routes no in every get
			# 	visit '/admin'
			# end
		end
	end
	
	# admin user tests ###########################################################
	# describe "Admin User Routes" do
	# 	it "redirects to the admin/login page if user not logged in" do
	# 		visit '/admin/users'
	# 	end

	# 	it "loads the admin/users page only if a user is logged in" do
	# 		visit '/admin/users'
	# 	end

	# 	it "admin/users page has a link to add a new user" do
	# 		visit '/admin/users'
	# 	end
		
	# 	it "admin/users page lists all users and their info" do
	# 		visit '/admin/users'
	# 	end

	# 	it "each user on admin/users page has links to edit and delete it" do
	# 		visit '/admin/users'
	# 	end
	# end
	
	# admin content tests ###########################################################
	# describe "Admin Content routes" do
	# 	it "redirects to the admin/login page if user not logged in" do
	# 		visit '/admin/content'
	# 	end

	# 	it "loads the admin/content page only if a user is logged in" do
	# 		visit '/admin/content'
	# 	end

	# 	it "admin/content page has a link to add a new content_section" do
	# 		visit '/admin/content'
	# 	end
		
	# 	it "admin/content page lists all content_sections in location order" do
	# 		visit '/admin/content'
	# 	end

	# 	it "each content_section on admin/content page displays its name, HL, body, link text, last updated" do
	# 		visit '/admin/content'
	# 	end

	# 	it "each content_section on admin/content page has links to edit and delete it" do
	# 		visit '/admin/content'
	# 	end
	# end
	
	# admin social tests ###########################################################
	# describe "Admin Social routes" do
	# 	describe "overall view" do
	# 		it "redirects to the admin/login page if user not logged in" do
	# 			visit '/admin/social'
	# 		end
	
	# 		it "loads the admin/social page only if a user is logged in" do
	# 			visit '/admin/social'
	# 		end
	# 	end


	# 	describe "platforms portion of view" do	
	# 		it "admin/social page has a link to add a new social_platform" do
	# 			visit '/admin/social'
	# 		end
			
	# 		it "admin/social page lists all social_platforms and their info" do
	# 			visit '/admin/social'
	# 		end
	
	# 		it "each social_platform on admin/social page has links to edit and delete it" do
	# 			visit '/admin/social'
	# 		end
	# 	end

	# 	describe "profiles portion of view" do
	# 		it "admin/social page has a link to add a new social_profile" do
	# 			visit '/admin/social'
	# 		end
			
	# 		it "admin/social page lists all social_profiles and their info" do
	# 			visit '/admin/social'
	# 		end
	
	# 		it "each social_profile on admin/social page has links to edit and delete it" do
	# 			visit '/admin/social'
	# 		end
	# 	end
    # end
end