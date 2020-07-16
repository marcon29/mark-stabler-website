require 'spec_helper'
require 'pry'

describe "SocialProfileslController" do
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

		profile_info = {name: "profile1", handle: "@profhandle1", display_order: 1, social_platform_id: @platform.id}
		@profile = SocialProfile.create(profile_info)
	end
	
	# non-user blocked access tests ###########################################################
	describe "no routes allow access to non-signed-in users" do
		it "GET social-profiles/new route redirects to the admin/login page if user not logged in" do
			visit '/social-profiles/new'

			expect(page.body).to include("<h1>Login</h1>")
			expect(page.body).to include('<form id="login-form"')
			expect(page.body).to include('method="post" action="/login"')
			expect(page).to have_field(:username)
			expect(page).to have_field(:password)
		end

		it "GET social-profiles/edit route redirects to the admin/login page if user not logged in" do
			visit "/social-profiles/#{@profile.slug}/edit"
			
			expect(page.body).to include("<h1>Login</h1>")
			expect(page.body).to include('<form id="login-form"')
			expect(page.body).to include('method="post" action="/login"')
			expect(page).to have_field(:username)
			expect(page).to have_field(:password)
		end
	end

	# new profile routes ###########################################################
	describe "new profile routes" do
		before do
			visit_admin_and_login_user
		end

		describe "displays and lets user interact with new profile form" do
			it "GET social-profiles/new route loads the social-profiles/new page and displays new profile form when user is logged in" do
				visit '/social-profiles/new'
				
				# check correct new form is displayed
				expect(page.body).to include("<h1>Add New Social Profile</h1>")
				expect(page.body).to include('<form id="new-profile-form"')
				expect(page.body).to include('method="post" action="/social-profiles"')
				expect(page).to have_field(:name)
				expect(page).to have_field(:handle)
				expect(page).to have_field(:display_order)
				
				# check that association list is correct
				expect(page).to have_select("social-platforms", options: SocialPlatform.all)
					# not sure if can do with collection of objects, may need to extract names, slugs or ids
			end		
			
			it "POST social-profiles/new route lets a user enter info to create a new social profile then loads admin/social page upon success" do
				new_profile_info = {name: "new profile1", handle: "@profhandle3", display_order: 3, social_platform_id: @platform.id}
				visit '/social-profiles/new'

				fill_in :name, :with => "#{new_profile_info[:name]}"
				fill_in :handle, :with => "#{new_profile_info[:handle]}"
				fill_in :display_order, :with => "#{new_profile_info[:display_order]}"
				select("#{new_profile_info[:social_platform_id]}", from: "social-platform-dropdown")
				click_button "Add Social Profile"

				# check profile created correctly				
				test_profile = SocialProfile.all.last
				expect(test_profile.name).to eq(new_profile_info[:name])
				expect(test_profile.handle).to eq(new_profile_info[:handle])
				expect(test_profile.display_order).to eq(new_profile_info[:display_order])
				expect(test_profile.social_platform).to eq(@platform)

				# check redirect 
				expect(page.body).to include("<h1>Social Management</h1>")
				expect(page.body).to include('<nav id="admin">')
				expect(page.body).to include('<a href="/social-profiles/new"')
			end
		end

		describe "won't create social profile if validated fields are blank" do
			it "POST social-profiles/new route won't create a new social profile if name field is left blank" do
				new_profile_info = {name: "new profile1", handle: "@profhandle3", display_order: 3, social_platform_id: @platform.id}
				visit '/social-profiles/new'
				total_profiles = SocialProfile.all.count

				# fill in form without name
				fill_in :name, :with => ""
				fill_in :handle, :with => "#{new_profile_info[:handle]}"
				fill_in :display_order, :with => "#{new_profile_info[:display_order]}"
				select("#{new_profile_info[:social_platform_id]}", from: "social-platform-dropdown")
				click_button "Add Social Profile"

				# expect SocialProfile.all.count to be same
				expect(SocialProfile.all.count).to eq total_profiles

				# expect info from social-profiles/new page after reload
				expect(page.body).to include("<h1>Add New Social Profile</h1>")
				expect(page.body).to include('<form id="new-profile-form"')
				expect(page.body).to include('method="post" action="/social-profiles"')
			end

			it "POST social-profiles/new route won't create a new social profile if handle field is left blank" do
				new_profile_info = {name: "new profile1", handle: "@profhandle3", display_order: 3, social_platform_id: @platform.id}
				visit '/social-profiles/new'
				total_profiles = SocialProfile.all.count

				# fill in form without handle
				fill_in :name, :with => "#{new_profile_info[:name]}"
				fill_in :handle, :with => ""
				fill_in :display_order, :with => "#{new_profile_info[:display_order]}"
				select("#{new_profile_info[:social_platform_id]}", from: "social-platform-dropdown")
				click_button "Add Social Profile"

				# expect SocialProfile.all.count to be same
				expect(SocialProfile.all.count).to eq total_profiles

				# expect info from social-profiles/new page after reload
				expect(page.body).to include("<h1>Add New Social Profile</h1>")
				expect(page.body).to include('<form id="new-profile-form"')
				expect(page.body).to include('method="post" action="/social-profiles"')
			end

			it "POST social-profiles/new route won't create a new social profile if an associated platform is not selected" do
				new_profile_info = {name: "new profile1", handle: "@profhandle3", display_order: 3, social_platform_id: @platform.id}
				visit '/social-profiles/new'
				total_profiles = SocialProfile.all.count

				# fill in form without display_order
				fill_in :name, :with => "#{new_profile_info[:name]}"
				fill_in :handle, :with => "#{new_profile_info[:handle]}"
				fill_in :display_order, :with => "#{new_profile_info[:display_order]}"
				click_button "Add Social Profile"

				# expect SocialProfile.all.count to be same
				expect(SocialProfile.all.count).to eq total_profiles

				# expect info from social-profiles/new page after reload
				expect(page.body).to include("<h1>Add New Social Profile</h1>")
				expect(page.body).to include('<form id="new-profile-form"')
				expect(page.body).to include('method="post" action="/social-profiles"')
			end
		end

		describe "won't create social profile if validated fields are bad" do
			it "POST social-profiles/new route won't create a new social profile if name is same as other profile" do
				new_profile_info = {name: "new profile1", handle: "@profhandle3", display_order: 3, social_platform_id: @platform.id}
				visit '/social-profiles/new'
				total_profiles = SocialProfile.all.count

				# fill in form with duplicated name
				fill_in :name, :with => "profile1"
				fill_in :handle, :with => "#{new_profile_info[:handle]}"
				fill_in :display_order, :with => "#{new_profile_info[:display_order]}"
				select("#{new_profile_info[:social_platform_id]}", from: "social-platform-dropdown")
				click_button "Add Social Profile"

				# expect SocialProfile.all.count to be same
				expect(SocialProfile.all.count).to eq total_profiles

				# expect info from social-profiles/new page after reload
				expect(page.body).to include("<h1>Add New Social Profile</h1>")
				expect(page.body).to include('<form id="new-profile-form"')
				expect(page.body).to include('method="post" action="/social-profiles"')
			end
			
			it "POST social-profiles/new route won't create a new social profile if handle is same as other profile associated to same platform" do
				new_profile_info = {name: "new profile1", handle: "@profhandle3", display_order: 3, social_platform_id: @platform.id}
				visit '/social-profiles/new'
				total_profiles = SocialProfile.all.count

				# fill in form with duplicated handle
				fill_in :name, :with => "#{new_profile_info[:name]}"
				fill_in :handle, :with => "@profhandle1"
				fill_in :display_order, :with => "#{new_profile_info[:display_order]}"
				select("#{new_profile_info[:social_platform_id]}", from: "social-platform-dropdown")
				click_button "Add Social Profile"

				# expect SocialProfile.all.count to be same
				expect(SocialProfile.all.count).to eq total_profiles

				# expect info from social-profiles/new page after reload
				expect(page.body).to include("<h1>Add New Social Profile</h1>")
				expect(page.body).to include('<form id="new-profile-form"')
				expect(page.body).to include('method="post" action="/social-profiles"')
			end

			it "POST social-profiles/new route won't create a new social profile if display_order is same as other profile" do
				new_profile_info = {name: "new profile1", handle: "@profhandle3", display_order: 3, social_platform_id: @platform.id}
				visit '/social-profiles/new'
				total_profiles = SocialProfile.all.count

				# fill in form with duplicated display_order
				fill_in :name, :with => "#{new_profile_info[:name]}"
				fill_in :handle, :with => "#{new_profile_info[:handle]}"
				fill_in :display_order, :with => 1
				select("#{new_profile_info[:social_platform_id]}", from: "social-platform-dropdown")
				click_button "Add Social Profile"

				# expect SocialProfile.all.count to be same
				expect(SocialProfile.all.count).to eq total_profiles

				# expect info from social-profiles/new page after reload
				expect(page.body).to include("<h1>Add New Social Profile</h1>")
				expect(page.body).to include('<form id="new-profile-form"')
				expect(page.body).to include('method="post" action="/social-profiles"')
			end

			it "POST social-profiles/new route won't create a new social profile if display_order isn't a number" do
				new_profile_info = {name: "new profile1", handle: "@profhandle3", display_order: 3, social_platform_id: @platform.id}
				visit '/social-profiles/new'
				total_profiles = SocialProfile.all.count

				# fill in form with bad handle
				fill_in :name, :with => "#{new_profile_info[:name]}"				
				fill_in :handle, :with => "#{new_profile_info[:handle]}"
				fill_in :display_order, :with => "three"
				select("#{new_profile_info[:social_platform_id]}", from: "social-platform-dropdown")
				click_button "Add Social Profile"

				# expect SocialProfile.all.count to be same
				expect(SocialProfile.all.count).to eq total_profiles

				# expect info from social-profiles/new page after reload
				expect(page.body).to include("<h1>Add New Social Profile</h1>")
				expect(page.body).to include('<form id="new-profile-form"')
				expect(page.body).to include('method="post" action="/social-profiles"')
			end

			it "POST social-profiles/new route will create a new social profile if display_order is blank (redirects to admin/social instead)" do
				new_profile_info = {name: "new profile1", handle: "@profhandle3", display_order: 3, social_platform_id: @platform.id}
				visit '/social-profiles/new'
				total_profiles = SocialProfile.all.count

				# fill in form with blank display_order
				fill_in :name, :with => "#{new_profile_info[:name]}"
				fill_in :handle, :with => "#{new_profile_info[:handle]}"
				fill_in :display_order, :with => ""
				select("#{new_profile_info[:social_platform_id]}", from: "social-platform-dropdown")
				click_button "Add Social Profile"

				# expect SocialProfile.all.count to be same
				expect(SocialProfile.all.count).to eq total_profiles+1
				expect(SocialProfile.all.last.display_order.blank?).to be true

				# expect info from admin/social page
				expect(page.body).to include("<h1>Social Management</h1>")
				expect(page.body).to include('<nav id="admin">')
				expect(page.body).to include('<a href="/social-profiles/new"')
			end
		end

		# it "POST Route displays the appropriate flash message upon redirect" do
		#	# think I can test the display in only processing routes no in every get
		# 	# visit '/social-profiles/new'
		# end
	end

	# update profile routes ###########################################################
	describe "update profile routes" do
		before do
			visit_admin_and_login_user
		end

		describe "displays and lets user interact with edit profile form" do
			it "GET social-profiles/edit route loads the social-profiles/edit page and displays edit profile form when user is logged in " do
				visit "/social-profiles/#{@profile.slug}/edit"

				# check correct edit form is displayed
				expect(page.body).to include("<h1>Edit #{@profile.name}</h1>")
				expect(page.body).to include('<form id="edit-profile-form"')
				expect(page.body).to include('method="post" action="/social-profiles/"profile1"')
				expect(page.body).to include('name="_method" value="patch"')

				# check that association list is correct
				expect(page).to have_select("social-platforms", options: SocialPlatform.all)
					# not sure if can do with collection of objects, may need to extract names, slugs or ids

				# check edit form fields are prefilled with correct existing object info
				expect(find_field("name").value).to eq("#{@profile.name}")
				expect(find_field("handle").value).to eq("#{@profile.handle}")
				expect(find_field("display_order").value).to eq("#{@profile.display_order}")
				expect(page).to have_select("social-platform-dropdown", selected: @profile.id)
			end
			
			it "POST social-profiles/edit route lets a user enter info to update an existing social profile then loads admin/social page upon success" do
				update_profile_info = {name: "update profile1", handle: "@profhandle4", display_order: 4, social_platform_id: @platform.id}
				platform2_info = {name: "platform2", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
				platform2 = SocialPlatform.create(platform2_info)
				visit "/social-profiles/#{@profile.slug}/edit"
				
				fill_in :name, :with => "#{update_profile_info[:name]}"
				fill_in :handle, :with => "#{update_profile_info[:handle]}"
				fill_in :display_order, :with => "#{update_profile_info[:display_order]}"
				select("#{platform2.id}", from: "social-platform-dropdown")
				click_button "Update Social Profile"

				# check profile updated correctly
				test_profile = SocialProfile.find(@profile.id)
				expect(test_profile.name).to eq(update_profile_info[:name])
				expect(test_profile.handle).to eq(update_profile_info[:handle])
				expect(test_profile.display_order).to eq(update_profile_info[:display_order])
				expect(test_profile.social_platform).to eq(platform2)

				# check redirect 
				expect(page.body).to include("<h1>Social Management</h1>")
				expect(page.body).to include('<nav id="admin">')
				expect(page.body).to include('<a href="/social-profiles/new"')
			end
		end

		describe "won't update social profile if validated fields are blank" do
			it "POST social-profiles/edit route won't update social profile if name field is left blank" do
				update_profile_info = {name: "update profile1", handle: "@profhandle4", display_order: 4, social_platform_id: @platform.id}
				platform2_info = {name: "platform2", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
				platform2 = SocialPlatform.create(platform2_info)
				visit "/social-profiles/#{@profile.slug}/edit"
				check = @profile.name
				
				# fill in form without name
				fill_in :name, :with => ""
				fill_in :handle, :with => "#{update_profile_info[:handle]}"
				fill_in :display_order, :with => "#{update_profile_info[:display_order]}"
				select("#{platform2.id}", from: "social-platform-dropdown")
				click_button "Update Social Profile"
				
				# expect name to be unchanged
				test_profile = SocialProfile.find(@profile.id)
				expect(test_profile.name).to eq(check)
				
				# expect info from social-profiles/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_profile.name}</h1>")
				expect(page.body).to include('<form id="edit-profile-form"')
			end

			it "POST social-profiles/edit route won't update social profile if handle field is left blank" do
				update_profile_info = {name: "update profile1", handle: "@profhandle4", display_order: 4, social_platform_id: @platform.id}
				platform2_info = {name: "platform2", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
				platform2 = SocialPlatform.create(platform2_info)
				visit "/social-profiles/#{@profile.slug}/edit"
				check = @profile.handle
				
				# fill in form without handle
				fill_in :name, :with => "#{update_profile_info[:name]}"
				fill_in :handle, :with => ""
				fill_in :display_order, :with => "#{update_profile_info[:display_order]}"
				select("#{platform2.id}", from: "social-platform-dropdown")
				click_button "Update Social Profile"
				
				# expect handle to be unchanged
				test_profile = SocialProfile.find(@profile.id)
				expect(test_profile.handle).to eq(check)
				
				# expect info from social-profiles/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_profile.name}</h1>")
				expect(page.body).to include('<form id="edit-profile-form"')
			end

			it "POST social-profiles/edit route won't update social profile if an associated platform unselected" do
				update_profile_info = {name: "update profile1", handle: "@profhandle4", display_order: 4, social_platform_id: @platform.id}
				platform2_info = {name: "platform2", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
				platform2 = SocialPlatform.create(platform2_info)
				visit "/social-profiles/#{@profile.slug}/edit"				
				check = @profile.name
				
				# fill in form without display_order
				fill_in :name, :with => "#{update_profile_info[:name]}"
				fill_in :handle, :with => "#{update_profile_info[:handle]}"
				fill_in :display_order, :with => ""
				select("default", from: "social-platform-dropdown")
				click_button "Update Social Profile"
				
				# expect display_order to be unchanged
				test_profile = SocialProfile.find(@profile.id)
				expect(test_profile.social_platform).to eq(check)
				expect(test_profile.social_platform).to eq(@platform)
				
				# expect info from social-profiles/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_profile.name}</h1>")
				expect(page.body).to include('<form id="edit-profile-form"')
			end
		end

		describe "won't update social profile if validated fields are bad" do
			it "POST social-profiles/edit route won't update social profile if name is same as other profile" do
				platform2_info = {name: "platform2", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
				platform2 = SocialPlatform.create(platform2_info)
				profile2_info = {name: "profile2", handle: "@profhandle2", display_order: 2, social_platform_id: @platform.id}
				profile2 = SocialProfile.create(profile2_info)
				update_profile_info = {name: "update profile1", handle: "@profhandle4", display_order: 4, social_platform_id: @platform.id}
				
				visit "/social-profiles/#{@profile.slug}/edit"
				check = @profile.name

				# fill in form with duplicated name
				fill_in :name, :with => "profile2"
				fill_in :handle, :with => "#{update_profile_info[:handle]}"
				fill_in :display_order, :with => "#{update_profile_info[:display_order]}"
				select("#{platform2.id}", from: "social-platform-dropdown")	
				click_button "Update Social Profile"

				# expect name to be unchanged
				test_profile = SocialProfile.find(@profile.id)
				expect(test_profile.name).to eq(check)
				
				# expect info from social-profiles/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_profile.name}</h1>")
				expect(page.body).to include('<form id="edit-profile-form"')
			end
			
			it "POST social-profiles/edit route won't update social profile if handle is same as other profile associated to same platform" do
				platform2_info = {name: "platform2", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
				platform2 = SocialPlatform.create(platform2_info)
				profile2_info = {name: "profile2", handle: "@profhandle2", display_order: 2, social_platform_id: @platform.id}
				profile2 = SocialProfile.create(profile2_info)
				update_profile_info = {name: "update profile1", handle: "@profhandle4", display_order: 4, social_platform_id: @platform.id}
				
				visit "/social-profiles/#{@profile.slug}/edit"
				check = @profile.handle

				# fill in form with duplicated handle
				fill_in :name, :with => "#{update_profile_info[:name]}"
				fill_in :handle, :with => "@profhandle2"
				fill_in :display_order, :with => "#{update_profile_info[:display_order]}"
				select("#{platform2.id}", from: "social-platform-dropdown")
				click_button "Update Social Profile"

				# expect handle to be unchanged
				test_profile = SocialProfile.find(@profile.id)
				expect(test_profile.handle).to eq check
				
				# expect info from social-profiles/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_profile.name}</h1>")
				expect(page.body).to include('<form id="edit-profile-form"')
			end

			it "POST social-profiles/edit route won't update social profile if display_order is same as other profile" do
				platform2_info = {name: "platform2", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
				platform2 = SocialPlatform.create(platform2_info)
				profile2_info = {name: "profile2", handle: "@profhandle2", display_order: 2, social_platform_id: @platform.id}
				profile2 = SocialProfile.create(profile2_info)
				update_profile_info = {name: "update profile1", handle: "@profhandle4", display_order: 4, social_platform_id: @platform.id}
				
				visit "/social-profiles/#{@profile.slug}/edit"
				check = @profile.display_order

				# fill in form with duplicated display_order
				fill_in :name, :with => "#{update_profile_info[:name]}"
				fill_in :handle, :with => "#{update_profile_info[:handle]}"
				fill_in :display_order, :with => 2
				select("#{platform2.id}", from: "social-platform-dropdown")
				click_button "Update Social Profile"

				# expect display_order to be unchanged
				test_profile = SocialProfile.find(@profile.id)
				expect(test_profile.display_order).to eq check
				
				# expect info from social-profiles/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_profile.name}</h1>")
				expect(page.body).to include('<form id="edit-profile-form"')
			end
			
			it "POST social-profiles/edit route won't update social profile if display_order isn't a number" do
				platform2_info = {name: "platform2", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
				platform2 = SocialPlatform.create(platform2_info)
				update_profile_info = {name: "update profile1", handle: "@profhandle4", display_order: 4, social_platform_id: @platform.id}
				visit "/social-profiles/#{@profile.slug}/edit"
				check = @profile.handle

				# fill in form with bad handle
				fill_in :name, :with => "#{update_profile_info[:name]}"
				fill_in :handle, :with => "#{update_profile_info[:handle]}"
				fill_in :display_order, :with => "four"
				select("#{platform2.id}", from: "social-platform-dropdown")
				click_button "Update Social Profile"

				# expect handle to be unchanged
				test_profile = SocialProfile.find(@profile.id)
				expect(test_profile.handle).to eq check
				
				# expect info from social-profiles/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_profile.name}</h1>")
				expect(page.body).to include('<form id="edit-profile-form"')
			end
			
			it "POST social-profiles/edit route will update social profile if display_order is blank (redirects to admin/social instead)" do
				platform2_info = {name: "platform2", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
				platform2 = SocialPlatform.create(platform2_info)
				update_profile_info = {name: "update profile1", handle: "@profhandle4", display_order: 4, social_platform_id: @platform.id}
				visit "/social-profiles/#{@profile.slug}/edit"

				# fill in form with blank display_order
				fill_in :name, :with => "#{update_profile_info[:name]}"
				fill_in :handle, :with => "#{update_profile_info[:handle]}"
				fill_in :display_order, :with => ""
				select("#{platform2.id}", from: "social-platform-dropdown")
				click_button "Update Social Profile"

				# expect display_order to be unchanged
				test_profile = SocialProfile.find(@profile.id)				
				expect(test_consec.page_location.blank?).to be true
				
				# expect info from admin/social page
				expect(page.body).to include("<h1>Social Management</h1>")
				expect(page.body).to include('<nav id="admin">')
				expect(page.body).to include('<a href="/social-profiles/new"')
			end
		end

		# it "POST Route displays the appropriate flash message upon redirect" do
		# 	# think I can test the display in only processing routes no in every get
		# 	# visit "/social-profiles/#{@profile.slug}/edit"
		# end
	end

	# delete social profile routes ###########################################################
	describe "delete social profile route" do
		before do
			visit_admin_and_login_user
		end

		it "DELETE social-profiles route deletes only the correct social profile then loads admin/social page upon success" do
			profile2_info = {name: "profile2", handle: "@profhandle2", display_order: 2, social_platform_id: @platform.id}
			profile2 = SocialProfile.create(profile2_info)

			visit '/admin/social'
			click_button "delete-#{profile2.slug}"
			
			expect(SocialProfile.all.include?(profile2)).to be false
			expect(SocialProfile.all.include?(@profile)).to be true
			expect(page.body).to include("<h1>Social Management</h1>")
			expect(page.body).to include('<nav id="admin">')
			expect(page.body).to include('<a href="/social-profiles/new"')
		end			

		# it "POST Route displays the appropriate flash message upon redirect" do
		# 	# think I can test the display in only processing routes no in every get
		# 	# visit '/admin/social'
		# end
	end
end

