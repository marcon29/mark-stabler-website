require 'spec_helper'
require 'pry'

describe "SocialPlatformslController" do
	before do
		user_info = {
			first_name: "test", 
			last_name: "user", 
			email: "tester1@example.com",
			username: "testuser1", 
			password: "test"
		}
		@user = User.create(user_info)

		platform_info = {name: "platform1", base_url: "https://www.example1.com", image_file_name: "icon1.png"}
		@platform = SocialPlatform.create(platform_info)
	end
		
	# non-user blocked access tests ###########################################################
	describe "no routes allow access to non-signed-in users" do
		it "GET social-platforms/new route redirects to the admin/login page if user not logged in" do
			visit '/social-platforms/new'

			expect(page.body).to include("<h1>Login</h1>")
			expect(page.body).to include('<form id="login-form"')
			expect(page.body).to include('method="post" action="/login"')
			expect(page).to have_field(:username)
			expect(page).to have_field(:password)
		end

		it "GET social-platforms/edit route redirects to the admin/login page if user not logged in" do
			visit "/social-platforms/#{@platform.slug}/edit"
			
			expect(page.body).to include("<h1>Login</h1>")
			expect(page.body).to include('<form id="login-form"')
			expect(page.body).to include('method="post" action="/login"')
			expect(page).to have_field(:username)
			expect(page).to have_field(:password)
		end
	end

	# new platform routes ###########################################################
	describe "new platform routes" do
		before do
			visit_admin_and_login_user
		end

		describe "displays and lets user interact with new platform form" do
			it "GET social-platforms/new route loads the social-platforms/new page and displays new platform form when user is logged in" do
				visit '/social-platforms/new'

				expect(page.body).to include("<h1>Add New Social Platform</h1>")
				expect(page.body).to include('<form id="new-platform-form"')
				expect(page.body).to include('method="post" action="/social-platforms"')
				expect(page).to have_field(:name)
				expect(page).to have_field(:base_url)
				expect(page).to have_field(:image_file_name)
			end		
			
			it "POST social-platforms/new route lets a user enter info to create a new social platform then loads admin/social page upon success" do
				new_platform_info = {name: "new platform3", base_url: "https://www.example3.com", image_file_name: "icon3.png"}
				visit '/social-platforms/new'

				fill_in :name, :with => "#{new_platform_info[:name]}"
				fill_in :base_url, :with => "#{new_platform_info[:base_url]}"
				fill_in :image_file_name, :with => "#{new_platform_info[:image_file_name]}"
				click_button "Add Social Platform"

				# check platform created correctly				
				test_platform = SocialPlatform.all.last
				expect(test_platform.name).to eq(new_platform_info[:name])
				expect(test_platform.base_url).to eq(new_platform_info[:base_url])
				expect(test_platform.image_file_name).to eq(new_platform_info[:image_file_name])

				# check redirect 
				expect(page.body).to include("<h1>Social Management</h1>")
				expect(page.body).to include('<nav id="admin">')
				expect(page.body).to include('<a href="/social-platforms/new"')
			end
		end

		describe "won't create social platform if validated fields are blank" do
			it "POST social-platforms/new route won't create a new social platform if name field is left blank" do
				new_platform_info = {name: "new platform3", base_url: "https://www.example3.com", image_file_name: "icon3.png"}
				visit '/social-platforms/new'
				total_platforms = SocialPlatform.all.count

				# fill in form without name
				fill_in :name, :with => ""
				fill_in :base_url, :with => "#{new_platform_info[:base_url]}"
				fill_in :image_file_name, :with => "#{new_platform_info[:image_file_name]}"
				click_button "Add Social Platform"

				# expect SocialPlatform.all.count to be same
				expect(SocialPlatform.all.count).to eq total_platforms

				# expect info from social-platforms/new page after reload
				expect(page.body).to include("<h1>Add New Social Platform</h1>")
				expect(page.body).to include('<form id="new-platform-form"')
				expect(page.body).to include('method="post" action="/social-platforms"')
			end

			it "POST social-platforms/new route won't create a new social platform if base_url field is left blank" do
				new_platform_info = {name: "new platform3", base_url: "https://www.example3.com", image_file_name: "icon3.png"}
				visit '/social-platforms/new'
				total_platforms = SocialPlatform.all.count

				# fill in form without base_url
				fill_in :name, :with => "#{new_platform_info[:name]}"
				fill_in :base_url, :with => ""
				fill_in :image_file_name, :with => "#{new_platform_info[:image_file_name]}"
				click_button "Add Social Platform"

				# expect SocialPlatform.all.count to be same
				expect(SocialPlatform.all.count).to eq total_platforms

				# expect info from social-platforms/new page after reload
				expect(page.body).to include("<h1>Add New Social Platform</h1>")
				expect(page.body).to include('<form id="new-platform-form"')
				expect(page.body).to include('method="post" action="/social-platforms"')
			end

			it "POST social-platforms/new route won't create a new social platform if image_file_name field is left blank" do
				new_platform_info = {name: "new platform3", base_url: "https://www.example3.com", image_file_name: "icon3.png"}
				visit '/social-platforms/new'
				total_platforms = SocialPlatform.all.count

				# fill in form without image_file_name
				fill_in :name, :with => "#{new_platform_info[:name]}"
				fill_in :base_url, :with => "#{new_platform_info[:base_url]}"
				fill_in :image_file_name, :with => ""
				click_button "Add Social Platform"

				# expect SocialPlatform.all.count to be same
				expect(SocialPlatform.all.count).to eq total_platforms

				# expect info from social-platforms/new page after reload
				expect(page.body).to include("<h1>Add New Social Platform</h1>")
				expect(page.body).to include('<form id="new-platform-form"')
				expect(page.body).to include('method="post" action="/social-platforms"')
			end
		end

		describe "won't create social platform if validated fields are bad" do
			it "POST social-platforms/new route won't create a new social platform if name is same as other platform" do
				new_platform_info = {name: "new platform3", base_url: "https://www.example3.com", image_file_name: "icon3.png"}
				visit '/social-platforms/new'
				total_platforms = SocialPlatform.all.count

				# fill in form with duplicated name
				fill_in :name, :with => "platform1"
				fill_in :base_url, :with => "#{new_platform_info[:base_url]}"
				fill_in :image_file_name, :with => "#{new_platform_info[:image_file_name]}"
				click_button "Add Social Platform"

				# expect SocialPlatform.all.count to be same
				expect(SocialPlatform.all.count).to eq total_platforms

				# expect info from social-platforms/new page after reload
				expect(page.body).to include("<h1>Add New Social Platform</h1>")
				expect(page.body).to include('<form id="new-platform-form"')
				expect(page.body).to include('method="post" action="/social-platforms"')
			end
			
			it "POST social-platforms/new route won't create a new social platform if base_url is same as other platform" do
				new_platform_info = {name: "new platform3", base_url: "https://www.example3.com", image_file_name: "icon3.png"}
				visit '/social-platforms/new'
				total_platforms = SocialPlatform.all.count

				# fill in form with duplicated base_url
				fill_in :name, :with => "#{new_platform_info[:name]}"
				fill_in :base_url, :with => "https://www.example1.com"
				fill_in :image_file_name, :with => "#{new_platform_info[:image_file_name]}"
				click_button "Add Social Platform"

				# expect SocialPlatform.all.count to be same
				expect(SocialPlatform.all.count).to eq total_platforms

				# expect info from social-platforms/new page after reload
				expect(page.body).to include("<h1>Add New Social Platform</h1>")
				expect(page.body).to include('<form id="new-platform-form"')
				expect(page.body).to include('method="post" action="/social-platforms"')
			end

			it "POST social-platforms/new route won't create a new social platform if image_file_name is same as other platform" do
				new_platform_info = {name: "new platform3", base_url: "https://www.example3.com", image_file_name: "icon3.png"}
				visit '/social-platforms/new'
				total_platforms = SocialPlatform.all.count

				# fill in form with duplicated image_file_name
				fill_in :name, :with => "#{new_platform_info[:name]}"
				fill_in :base_url, :with => "#{new_platform_info[:base_url]}"
				fill_in :image_file_name, :with => "icon1.png"
				click_button "Add Social Platform"

				# expect SocialPlatform.all.count to be same
				expect(SocialPlatform.all.count).to eq total_platforms

				# expect info from social-platforms/new page after reload
				expect(page.body).to include("<h1>Add New Social Platform</h1>")
				expect(page.body).to include('<form id="new-platform-form"')
				expect(page.body).to include('method="post" action="/social-platforms"')
			end

			it "POST social-platforms/new route won't create a new social platform if base_url doesn't match standard URL format" do
				new_platform_info = {name: "new platform3", base_url: "https://www.example3.com", image_file_name: "icon3.png"}
				visit '/social-platforms/new'
				total_platforms = SocialPlatform.all.count

				# fill in form with bad base_url
				fill_in :name, :with => "#{new_platform_info[:name]}"
				fill_in :base_url, :with => "https://www.exam ple3.com"
				fill_in :image_file_name, :with => "#{new_platform_info[:image_file_name]}"
				click_button "Add Social Platform"

				# expect SocialPlatform.all.count to be same
				expect(SocialPlatform.all.count).to eq total_platforms

				# expect info from social-platforms/new page after reload
				expect(page.body).to include("<h1>Add New Social Platform</h1>")
				expect(page.body).to include('<form id="new-platform-form"')
				expect(page.body).to include('method="post" action="/social-platforms"')
			end

			it "POST social-platforms/new route won't create a new social platform if image_file_name is wrong file type" do
				new_platform_info = {name: "new platform3", base_url: "https://www.example3.com", image_file_name: "icon3.png"}
				visit '/social-platforms/new'
				total_platforms = SocialPlatform.all.count

				# fill in form with bad image_file_name
				fill_in :name, :with => "#{new_platform_info[:name]}"
				fill_in :base_url, :with => "#{new_platform_info[:base_url]}"
				fill_in :image_file_name, :with => "icon3.erb"
				click_button "Add Social Platform"

				# expect SocialPlatform.all.count to be same
				expect(SocialPlatform.all.count).to eq total_platforms

				# expect info from social-platforms/new page after reload
				expect(page.body).to include("<h1>Add New Social Platform</h1>")
				expect(page.body).to include('<form id="new-platform-form"')
				expect(page.body).to include('method="post" action="/social-platforms"')
			end
		end

		# it "POST Route displays the appropriate flash message upon redirect" do
		#	# think I can test the display in only processing routes no in every get
		# 	# visit '/social-platforms/new'
		# end
	end

	# update platform routes ###########################################################
	describe "update platform routes" do
		before do
			visit_admin_and_login_user
		end

		describe "displays and lets user interact with edit platform form" do
			it "GET social-platforms/edit route loads the social-platforms/edit page and displays edit platform form when user is logged in " do			
				visit "/social-platforms/#{@platform.slug}/edit"

				# check correct edit form is displayed
				expect(page.body).to include("<h1>Edit #{@platform.name}</h1>")
				expect(page.body).to include('<form id="edit-platform-form"')
				expect(page.body).to include('method="post" action="/social-platforms/"platform1"')
				expect(page.body).to include('name="_method" value="patch"')

				# check edit form fields are prefilled with correct existing object info
				expect(find_field("name").value).to eq("#{@platform.name}")
				expect(find_field("base_url").value).to eq("#{@platform.base_url}")
				expect(find_field("image_file_name").value).to eq("#{@platform.image_file_name}")
			end
			
			it "POST social-platforms/edit route lets a user enter info to update an existing social platform then loads admin/social page upon success" do
				update_platform_info = {name: "update platform4", base_url: "https://www.example4.com", image_file_name: "icon4.png"}
				visit "/social-platforms/#{@platform.slug}/edit"
				
				fill_in :name, :with => "#{update_platform_info[:name]}"
				fill_in :base_url, :with => "#{update_platform_info[:base_url]}"
				fill_in :image_file_name, :with => "#{update_platform_info[:image_file_name]}"	
				click_button "Update Social Platform"

				# check platform updated correctly
				test_platform = SocialPlatform.find(@platform.id)
				expect(test_platform.name).to eq(update_platform_info[:name])
				expect(test_platform.base_url).to eq(update_platform_info[:base_url])
				expect(test_platform.image_file_name).to eq(update_platform_info[:image_file_name])

				# check redirect 
				expect(page.body).to include("<h1>Social Management</h1>")
				expect(page.body).to include('<nav id="admin">')
				expect(page.body).to include('<a href="/social-platforms/new"')
			end
		end

		describe "won't update social platform if validated fields are blank" do
			it "POST social-platforms/edit route won't update social platform if name field is left blank" do
				update_platform_info = {name: "update platform4", base_url: "https://www.example4.com", image_file_name: "icon4.png"}
				visit "/social-platforms/#{@platform.slug}/edit"
				check = @platform.name
				
				# fill in form without name
				fill_in :name, :with => ""
				fill_in :base_url, :with => "#{update_platform_info[:base_url]}"
				fill_in :image_file_name, :with => "#{update_platform_info[:image_file_name]}"	
				click_button "Update Social Platform"
				
				# expect name to be unchanged
				test_platform = SocialPlatform.find(@platform.id)
				expect(test_platform.name).to eq(check)
				
				# expect info from social-platforms/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_platform.name}</h1>")
				expect(page.body).to include('<form id="edit-platform-form"')
			end

			it "POST social-platforms/edit route won't update social platform if base_url field is left blank" do
				update_platform_info = {name: "update platform4", base_url: "https://www.example4.com", image_file_name: "icon4.png"}
				visit "/social-platforms/#{@platform.slug}/edit"
				check = @platform.base_url
				
				# fill in form without base_url
				fill_in :name, :with => "#{update_platform_info[:name]}"
				fill_in :base_url, :with => ""
				fill_in :image_file_name, :with => "#{update_platform_info[:image_file_name]}"	
				click_button "Update Social Platform"
				
				# expect base_url to be unchanged
				test_platform = SocialPlatform.find(@platform.id)
				expect(test_platform.base_url).to eq(check)
				
				# expect info from social-platforms/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_platform.name}</h1>")
				expect(page.body).to include('<form id="edit-platform-form"')
			end

			it "POST social-platforms/edit route won't update social platform if image_file_name field is left blank" do
				update_platform_info = {name: "update platform4", base_url: "https://www.example4.com", image_file_name: "icon4.png"}
				visit "/social-platforms/#{@platform.slug}/edit"
				check = @platform.image_file_name
				
				# fill in form without image_file_name
				fill_in :name, :with => "#{update_platform_info[:name]}"
				fill_in :base_url, :with => "#{update_platform_info[:base_url]}"
				fill_in :image_file_name, :with => ""
				click_button "Update Social Platform"
				
				# expect image_file_name to be unchanged
				test_platform = SocialPlatform.find(@platform.id)
				expect(test_platform.image_file_name).to eq(check)
				
				# expect info from social-platforms/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_platform.name}</h1>")
				expect(page.body).to include('<form id="edit-platform-form"')
			end
		end

		describe "won't update social platform if validated fields are bad" do
			it "POST social-platforms/edit route won't update social platform if name is same as other platform" do
				platform2_info = {name: "platform2", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
				platform2 = SocialPlatform.create(platform2_info)
				update_platform_info = {name: "update platform4", base_url: "https://www.example4.com", image_file_name: "icon4.png"}
				
				visit "/social-platforms/#{@platform.slug}/edit"
				check = @platform.name

				# fill in form with duplicated name
				fill_in :name, :with => "platform2"
				fill_in :base_url, :with => "#{update_platform_info[:base_url]}"
				fill_in :image_file_name, :with => "#{update_platform_info[:image_file_name]}"	
				click_button "Update Social Platform"

				# expect name to be unchanged
				test_platform = SocialPlatform.find(@platform.id)
				expect(test_platform.name).to eq(check)
				
				# expect info from social-platforms/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_platform.name}</h1>")
				expect(page.body).to include('<form id="edit-platform-form"')
			end
			
			it "POST social-platforms/edit route won't update social platform if base_url is same as other platform" do
				platform2_info = {name: "platform2", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
				platform2 = SocialPlatform.create(platform2_info)
				update_platform_info = {name: "update platform4", base_url: "https://www.example4.com", image_file_name: "icon4.png"}
				
				visit "/social-platforms/#{@platform.slug}/edit"
				check = @platform.base_url

				# fill in form with duplicated base_url
				fill_in :name, :with => "#{update_platform_info[:name]}"
				fill_in :base_url, :with => "https://www.example2.com"
				fill_in :image_file_name, :with => "#{update_platform_info[:image_file_name]}"	
				click_button "Update Social Platform"

				# expect base_url to be unchanged
				test_platform = SocialPlatform.find(@platform.id)
				expect(test_platform.base_url).to eq check
				
				# expect info from social-platforms/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_platform.name}</h1>")
				expect(page.body).to include('<form id="edit-platform-form"')
			end

			it "POST social-platforms/edit route won't update social platform if image_file_name is same as other platform" do
				platform2_info = {name: "platform2", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
				platform2 = SocialPlatform.create(platform2_info)
				update_platform_info = {name: "update platform4", base_url: "https://www.example4.com", image_file_name: "icon4.png"}
				
				visit "/social-platforms/#{@platform.slug}/edit"
				check = @platform.image_file_name

				# fill in form with duplicated image_file_name
				fill_in :name, :with => "#{update_platform_info[:name]}"
				fill_in :base_url, :with => "#{update_platform_info[:base_url]}"
				fill_in :image_file_name, :with => "icon2.png"
				click_button "Update Social Platform"

				# expect image_file_name to be unchanged
				test_platform = SocialPlatform.find(@platform.id)
				expect(test_platform.image_file_name).to eq check
				
				# expect info from social-platforms/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_platform.name}</h1>")
				expect(page.body).to include('<form id="edit-platform-form"')
			end
			
			it "POST social-platforms/edit route won't update social platform if base_url doesn't match standard URL format" do
				update_platform_info = {name: "update platform4", base_url: "https://www.example4.com", image_file_name: "icon4.png"}
				visit "/social-platforms/#{@platform.slug}/edit"
				check = @platform.base_url

				# fill in form with bad base_url
				fill_in :name, :with => "#{update_platform_info[:name]}"
				fill_in :base_url, :with => "https://www.example4"
				fill_in :image_file_name, :with => "#{update_platform_info[:image_file_name]}"	
				click_button "Update Social Platform"

				# expect base_url to be unchanged
				test_platform = SocialPlatform.find(@platform.id)
				expect(test_platform.base_url).to eq check
				
				# expect info from social-platforms/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_platform.name}</h1>")
				expect(page.body).to include('<form id="edit-platform-form"')
			end

			it "POST social-platforms/edit route won't update social platform if image_file_name is wrong file type" do
				update_platform_info = {name: "update platform4", base_url: "https://www.example4.com", image_file_name: "icon4.png"}
				visit "/social-platforms/#{@platform.slug}/edit"
				check = @platform.image_file_name

				# fill in form with bad image_file_name
				fill_in :name, :with => "#{update_platform_info[:name]}"
				fill_in :base_url, :with => "#{update_platform_info[:base_url]}"
				fill_in :image_file_name, :with => "icon4.gif"
				click_button "Update Social Platform"

				# expect image_file_name to be unchanged
				test_platform = SocialPlatform.find(@platform.id)
				expect(test_platform.image_file_name).to eq check
				
				# expect info from social-platforms/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_platform.name}</h1>")
				expect(page.body).to include('<form id="edit-platform-form"')
			end
		end

		# it "POST Route displays the appropriate flash message upon redirect" do
		# 	# think I can test the display in only processing routes no in every get
		# 	# visit "/social-platforms/#{@platform.slug}/edit"
		# end
	end

	# delete social platform routes ###########################################################
	describe "delete social platform route" do
		before do
			visit_admin_and_login_user
		end

		it "DELETE social-platforms route deletes only the correct social platform then loads admin/social page upon success" do
			platform2_info = {name: "platform2", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
			platform2 = SocialPlatform.create(platform2_info)

			visit '/admin/social'
			click_button "delete-#{platform2.slug}"
			
			expect(SocialPlatform.all.include?(platform2)).to be false
			expect(SocialPlatform.all.include?(@platform)).to be true
			expect(page.body).to include("<h1>Social Management</h1>")
			expect(page.body).to include('<nav id="admin">')
			expect(page.body).to include('<a href="/social-platforms/new"')
		end			

		# it "POST Route displays the appropriate flash message upon redirect" do
		# 	# think I can test the display in only processing routes no in every get
		# 	# visit '/admin/social'
		# end
	end
end