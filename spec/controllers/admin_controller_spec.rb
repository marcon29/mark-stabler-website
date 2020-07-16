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
			expect(page.body).to include('method="post" action="/login"')
			expect(page).to have_field(:username)
			expect(page).to have_field(:password)
		end

		it "admin/content route redirects to the admin/login page if user not logged in" do
			visit '/admin/content'

			expect(page.body).to include("<h1>Login</h1>")
			expect(page.body).to include('<form id="login-form"')
			expect(page.body).to include('method="post" action="/login"')
			expect(page).to have_field(:username)
			expect(page).to have_field(:password)
		end

		it "admin/social route redirects to the admin/login page if user not logged in" do
			visit '/admin/social'

			expect(page.body).to include("<h1>Login</h1>")
			expect(page.body).to include('<form id="login-form"')
			expect(page.body).to include('method="post" action="/login"')
			expect(page).to have_field(:username)
			expect(page).to have_field(:password)
		end
	end

	# admin home tests ###########################################################
	describe "Admin home routes" do
		describe "admin route" do
			it "loads the admin/login page and displays login form when user is not logged in" do
				visit '/admin'

				expect(page.body).to include("<h1>Login</h1>")
				expect(page.body).to include('<form id="login-form"')
				expect(page.body).to include('method="post" action="/login"')
				expect(page).to have_field(:username)
				expect(page).to have_field(:password)
			end
			
			it "loads the admin/index page when user is logged in, which displays admin nav, links to main admin pages and to logout" do
				visit '/admin'
				login_user
				
				expect(page.body).to include("<h1>Admin Home</h1>")
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
				
				expect(page.body).to include("<h1>Admin Home</h1>")
			end

			it "won't let an unregistered user log in" do
				visit '/admin'
				fill_in :username, :with => "baduser1"
				fill_in :password, :with => "test"
				click_button "Log In"
								
				expect(page.body).to include("<h1>Login</h1>")
			end

			it "won't let a registered user log in with wrong password" do
				visit '/admin'
				fill_in :username, :with => "testuser1"
				fill_in :password, :with => "badpassword"
				click_button "Log In"
								
				expect(page.body).to include("<h1>Login</h1>")
			end

			it "won't log a user in if username field is left blank" do
				visit '/admin'
				fill_in :username, :with => ""
				fill_in :password, :with => "test"
				click_button "Log In"

				expect(page.body).to include("<h1>Login</h1>")
			end

			it "won't log a user in if password field is left blank" do
				visit '/admin'
				fill_in :username, :with => "testuser1"
				fill_in :password, :with => ""
				click_button "Log In"
				
				expect(page.body).to include("<h1>Login</h1>")
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

				expect(page.body).to include("<h1>Login</h1>")
			end

			# it "displays the appropriate flash message upon redirect" do
			#	# think I can test the display in only processing routes no in every get
			# 	visit '/admin'
			# end
		end
	end
	
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
		
		it "admin/users page lists all users in alphabetical order (by username) and shows for each: all info, edit and delete buttons" do
			user2_info = {first_name: "test2", last_name: "user2", email: "tester2@example.com",username: "testuser2", password: "test"}
			user3_info = {first_name: "test3", last_name: "user3", email: "tester3@example.com",username: "testuser3", password: "test"}
			user4_info = {first_name: "test4", last_name: "user4", email: "tester4@example.com",username: "testuser4", password: "test"}
			User.create(user2_info)
			User.create(user3_info)
			User.create(user4_info)

			visit '/admin/users'

			User.all.order("username ASC").each do |user|
				expect(page.body).to include(user.username)
				expect(page.body).to include(user.full_name)
				expect(page.body).to include(user.email)
				expect(page.body).to include("/users/#{user.username}/edit")
				expect(page.body).to include("/users/#{user.username}")
			end
		end
	end
	
	# admin content tests ###########################################################
	describe "Admin Content routes" do
		before do
			visit_admin_and_login_user
		end

		it "loads the admin/content page only if a user is logged in" do
			visit '/admin/content'
			
			expect(page.body).to include("<h1>Content Management</h1>")
			expect(page.body).to include('<nav id="admin">')
			expect(page.body).to include('<a href="/content-sections/new"')
		end
		
		it "admin/content page lists all content_sections in location order and shows for each: name, HL, body, link, last updated, edit and delete buttons" do
			con_sec1_info = {name: "content1", css_class: "text-box", page_location: 3, headline: "Test Content1", body_copy: "body copy for test content1", link_url: "www.example1.com", link_text: "example1"}
			con_sec2_info = {name: "content2", css_class: "text-box", page_location: 2, headline: "Test Content2", body_copy: "body copy for test content2", link_url: "www.example2.com", link_text: "example2"}
			con_sec3_info = {name: "content3", css_class: "text-box", page_location: 1, headline: "Test Content3", body_copy: "body copy for test content3", link_url: "www.example3.com", link_text: "example3"}
			ContentSection.create(con_sec1_info)
			ContentSection.create(con_sec2_info)
			ContentSection.create(con_sec3_info)

			visit '/admin/content'

			counter = 0 	# this is for checking that list is in proper order
			ContentSection.all.order("page_location ASC").each do |con_sec|
				expect(con_sec.page_location).to eq(counter += 1)
				expect(page.body).to include(con_sec.name)
				expect(page.body).to include(con_sec.headline)
				expect(page.body).to include(con_sec.body_copy)
				expect(page.body).to include(con_sec.link_url)
				expect(page.body).to include(con_sec.link_text)
				expect(page.body).to include("/content-sections/#{con_sec.slug}/edit")
				expect(page.body).to include("/content-sections/#{con_sec.slug}")
			end
		end
	end
	
	# admin social tests ###########################################################
	describe "Admin Social routes" do
		before do
			visit_admin_and_login_user
		end

		it "loads the admin/social page only if a user is logged in" do
			visit '/admin/social'
			
			expect(page.body).to include("<h1>Social Management</h1>")
			expect(page.body).to include('<nav id="admin">')
			expect(page.body).to include('<a href="/social-platforms/new"')
			expect(page.body).to include('<a href="/social-profiles/new"')
		end
		
		it "admin/social page lists all social_platforms and shows for each: all info, edit and delete buttons" do
			platform1_info = {name: "platform name1", base_url: "https://www.example1.com", image_file_name: "icon1.png"}
            platform2_info = {name: "platform name2", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
			SocialPlatform.create(platform1_info)
			SocialPlatform.create(platform2_info)

			visit '/admin/social'
			
			SocialPlatform.all.order("name ASC").each do |platform|
				expect(page.body).to include(platform.name)
				expect(page.body).to include(platform.base_url)
				expect(page.body).to include(platform.image_file_name)
				expect(page.body).to include("/social-platforms/#{platform.slug}/edit")
				expect(page.body).to include("/social-platforms/#{platform.slug}")
			end
		end
		
		it "admin/social page lists all social_profiles and shows for each: all info, edit and delete buttons" do
			platform1_info = {name: "zplatform name1", base_url: "https://www.example1.com", image_file_name: "icon1.png"}
            platform2_info = {name: "aplatform name2", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
			platform1 = SocialPlatform.create(platform1_info)
			platform2 = SocialPlatform.create(platform2_info)

			profile1_info = {name: "profile name1", handle: "@profhandle1", display_order: 6, social_platform_id: platform1.id}
			profile2_info = {name: "profile name2", handle: "@profhandle2", display_order: 5, social_platform_id: platform2.id}
			profile3_info = {name: "profile name3", handle: "@profhandle3", display_order: 4, social_platform_id: platform1.id}
			profile4_info = {name: "profile name4", handle: "@profhandle4", display_order: 3, social_platform_id: platform2.id}
			profile5_info = {name: "profile name5", handle: "@profhandle5", display_order: 2, social_platform_id: platform1.id}
			profile6_info = {name: "profile name6", handle: "@profhandle6", display_order: 1, social_platform_id: platform2.id}
			SocialProfile.create(profile1_info)
			SocialProfile.create(profile2_info)
			SocialProfile.create(profile3_info)
			SocialProfile.create(profile4_info)
			SocialProfile.create(profile5_info)
			SocialProfile.create(profile6_info)

			visit '/admin/social'

			counter = 0 	# this is for checking that list is in proper order
			SocialProfile.all.order("display_order ASC").each do |profile|
				expect(profile.display_order).to eq(counter += 1)
				expect(page.body).to include(profile.name)
				expect(page.body).to include(profile.handle)
				expect(page.body).to include(profile.display_order.to_s)
				expect(page.body).to include("/social-profiles/#{profile.slug}/edit")
				expect(page.body).to include("/social-profiles/#{profile.slug}")
			end
		end
    end
end