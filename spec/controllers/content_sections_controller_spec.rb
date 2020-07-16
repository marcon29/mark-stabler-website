require 'spec_helper'
require 'pry'

describe "ContentSectionslController" do
	before do
		consec_info = {
			name: "test content1", 
			css_class: "text-box", 
			page_location: 1, 
			headline: "HL for test content1", 
			body_copy: "Body copy for test content1.", 
			link_url: "https://www.example1.com", 
			link_text: "example1"
		}

        @consec = ContentSection.create(consec_info)
	end
	
	# non-user blocked access tests ###########################################################
	describe "no routes allow access to non-signed-in users" do
		it "GET content-sections/new route redirects to the admin/login page if user not logged in" do
			visit '/content-sections/new'

			expect(page.body).to include("<h1>Login</h1>")
			expect(page.body).to include('<form id="login-form"')
			expect(page.body).to include('method="post" action="/login"')
			expect(page).to have_field(:headline)
			expect(page).to have_field(:body_copy)
		end

		it "GET content-sections/edit route redirects to the admin/login page if user not logged in" do
			visit "/content-sections/#{@consec.slug}/edit"
			
			expect(page.body).to include("<h1>Login</h1>")
			expect(page.body).to include('<form id="login-form"')
			expect(page.body).to include('method="post" action="/login"')
			expect(page).to have_field(:headline)
			expect(page).to have_field(:body_copy)
		end
	end

	# new content section routes ###########################################################
	describe "new content section routes" do
		before do
			visit_admin_and_login_user
		end

		describe "displays and lets user interact with new content section form" do
			it "GET content-sections/new route loads the content-sections/new page and displays new content section form when user is logged in" do
				visit '/content-sections/new'

				expect(page.body).to include("<h1>Add New Content Section</h1>")
				expect(page.body).to include('<form id="new-content-form"')
				expect(page.body).to include('method="post" action="/content-sections/new"')
				expect(page).to have_field(:name)
				expect(page).to have_field(:css_class)
				expect(page).to have_field(:page_location)
				expect(page).to have_field(:headline)
				expect(page).to have_field(:body_copy)
				expect(page).to have_field(:link_url)
				expect(page).to have_field(:link_text)
			end		
			
			it "POST content-sections/new route lets a user enter info to create a new content section then loads admin/content page upon success" do
				new_consec_info = {name: "new content1", css_class: "text-box", page_location: 2, headline: "HL for new content1", body_copy: "Body copy for new content1.", link_url: "https://www.example2.com", link_text: "example2"}
				visit '/content-sections/new'

				fill_in :name, :with => "#{new_consec_info[:name]}"
				fill_in :css_class, :with => "#{new_consec_info[:css_class]}"
				fill_in :page_location, :with => new_consec_info[:page_location]
				fill_in :headline, :with => "#{new_consec_info[:headline]}"
				fill_in :body_copy, :with => "#{new_consec_info[:body_copy]}"
				fill_in :link_url, :with => "#{new_consec_info[:link_url]}"
				fill_in :link_text, :with => "#{new_consec_info[:link_text]}"
				click_button "Add Content Section"

				# check content section created correctly
				test_consec = ContentSection.all.last
				expect(test_consec.name).to eq(new_consec_info[:name])
				expect(test_consec.css_class).to eq(new_consec_info[:css_class])
				expect(test_consec.page_location).to eq new_consec_info[:page_location]
				expect(test_consec.headline).to eq(new_consec_info[:headline])
				expect(test_consec.body_copy).to eq(new_consec_info[:body_copy])
				expect(test_consec.link_url).to eq(new_consec_info[:link_url])
				expect(test_consec.link_text).to eq(new_consec_info[:link_text])
				

				# check redirect (these should be good)
				expect(page.body).to include("<h1>Content Management</h1>")
				expect(page.body).to include('<nav id="admin">')
				expect(page.body).to include('<a href="/content-sections/new"')
			end
		end

		describe "won't create content section if validated fields are blank" do
			it "POST content-sections/new route won't create a new content section if name field is left blank" do
				new_consec_info = {name: "new content1", css_class: "text-box", page_location: 2, headline: "HL for new content1", body_copy: "Body copy for new content1.", link_url: "https://www.example2.com", link_text: "example2"}
				visit '/content-sections/new'
				total_consecs = ContentSection.all.count

				# fill in form without name
				fill_in :name, :with => ""
				fill_in :css_class, :with => "#{new_consec_info[:css_class]}"
				fill_in :page_location, :with => new_consec_info[:page_location]
				fill_in :headline, :with => "#{new_consec_info[:headline]}"
				fill_in :body_copy, :with => "#{new_consec_info[:body_copy]}"
				fill_in :link_url, :with => "#{new_consec_info[:link_url]}"
				fill_in :link_text, :with => "#{new_consec_info[:link_text]}"
				click_button "Add Content Section"

				# expect ContentSection.all.count to be same
				expect(ContentSection.all.count).to eq total_consecs

				# expect info from content-sections/new page after reload
				expect(page.body).to include("<h1>Add New Content</h1>")
				expect(page.body).to include('<form id="new-content-form"')
				expect(page.body).to include('method="post" action="/content-sections/new"')
			end
		end

		describe "won't create content section if validated fields are bad" do
			it "POST content-sections/new route won't create a new content section if name is same as other content section" do
				new_consec_info = {name: "new content1", css_class: "text-box", page_location: 2, headline: "HL for new content1", body_copy: "Body copy for new content1.", link_url: "https://www.example2.com", link_text: "example2"}
				visit '/content-sections/new'
				total_consecs = ContentSection.all.count

				# fill in form with duplicated name
				fill_in :name, :with => "test content1"
				fill_in :css_class, :with => "#{new_consec_info[:css_class]}"
				fill_in :page_location, :with => new_consec_info[:page_location]
				fill_in :headline, :with => "#{new_consec_info[:headline]}"
				fill_in :body_copy, :with => "#{new_consec_info[:body_copy]}"
				fill_in :link_url, :with => "#{new_consec_info[:link_url]}"
				fill_in :link_text, :with => "#{new_consec_info[:link_text]}"
				click_button "Add Content Section"

				# expect ContentSection.all.count to be same
				expect(ContentSection.all.count).to eq total_consecs

				# expect info from content-sections/new page after reload
				expect(page.body).to include("<h1>Add New Content</h1>")
				expect(page.body).to include('<form id="new-content-form"')
				expect(page.body).to include('method="post" action="/content-sections/new"')
			end
			
			it "POST content-sections/new route won't create a new content section if page_location is same as other content section" do
				new_consec_info = {name: "new content1", css_class: "text-box", page_location: 2, headline: "HL for new content1", body_copy: "Body copy for new content1.", link_url: "https://www.example2.com", link_text: "example2"}
				visit '/content-sections/new'
				total_consecs = ContentSection.all.count

				# fill in form with duplicated page_location
				fill_in :name, :with => "#{new_consec_info[:name]}"
				fill_in :css_class, :with => "#{new_consec_info[:css_class]}"
				fill_in :page_location, :with => 1
				fill_in :headline, :with => "#{new_consec_info[:headline]}"
				fill_in :body_copy, :with => "#{new_consec_info[:body_copy]}"
				fill_in :link_url, :with => "#{new_consec_info[:link_url]}"
				fill_in :link_text, :with => "#{new_consec_info[:link_text]}"
				click_button "Add Content Section"

				# expect ContentSection.all.count to be same
				expect(ContentSection.all.count).to eq total_consecs

				# expect info from content-sections/new page after reload
				expect(page.body).to include("<h1>Add New Content</h1>")
				expect(page.body).to include('<form id="new-content-form"')
				expect(page.body).to include('method="post" action="/content-sections/new"')
			end

			it "POST content-sections/edit route won't create a new content section if page_location isn't a number" do
				new_consec_info = {name: "new content1", css_class: "text-box", page_location: 2, headline: "HL for new content1", body_copy: "Body copy for new content1.", link_url: "https://www.example2.com", link_text: "example2"}
				visit '/content-sections/new'
				total_consecs = ContentSection.all.count

				# fill in form with bad page_location
				fill_in :name, :with => "#{new_consec_info[:name]}"
				fill_in :css_class, :with => "#{new_consec_info[:css_class]}"
				fill_in :page_location, :with => "one"
				fill_in :headline, :with => "#{new_consec_info[:headline]}"
				fill_in :body_copy, :with => "#{new_consec_info[:body_copy]}"
				fill_in :link_url, :with => "#{new_consec_info[:link_url]}"
				fill_in :link_text, :with => "#{new_consec_info[:link_text]}"
				click_button "Add Content Section"

				# expect ContentSection.all.count to be same
				expect(ContentSection.all.count).to eq total_consecs

				# expect info from content-sections/new page after reload
				expect(page.body).to include("<h1>Add New Content</h1>")
				expect(page.body).to include('<form id="new-content-form"')
				expect(page.body).to include('method="post" action="/content-sections/new"')
			end

			it "POST content-sections/edit route will create a new content section if page_location is blank" do
				new_consec_info = {name: "new content1", css_class: "text-box", page_location: 2, headline: "HL for new content1", body_copy: "Body copy for new content1.", link_url: "https://www.example2.com", link_text: "example2"}
				visit '/content-sections/new'
				total_consecs = ContentSection.all.count

				# fill in form with blank page_location
				fill_in :name, :with => "#{new_consec_info[:name]}"
				fill_in :css_class, :with => "#{new_consec_info[:css_class]}"
				fill_in :page_location, :with => ""
				fill_in :headline, :with => "#{new_consec_info[:headline]}"
				fill_in :body_copy, :with => "#{new_consec_info[:body_copy]}"
				fill_in :link_url, :with => "#{new_consec_info[:link_url]}"
				fill_in :link_text, :with => "#{new_consec_info[:link_text]}"
				click_button "Add Content Section"

				# expect ContentSection.all.count to be same
				expect(ContentSection.all.count).to eq total_consecs+1
				expect(ContentSection.all.last.page_location.blank?).to be true

				# expect info from content-sections/new page after reload
				expect(page.body).to include("<h1>Add New Content</h1>")
				expect(page.body).to include('<form id="new-content-form"')
				expect(page.body).to include('method="post" action="/content-sections/new"')
			end

			
		end

		# it "POST Route displays the appropriate flash message upon redirect" do
		#	# think I can test the display in only processing routes no in every get
		# 	# visit '/content-sections/new'
		# end
	end

	# update content section routes ###########################################################
	describe "update content section routes" do
		before do
			visit_admin_and_login_user
		end

		describe "displays and lets user interact with edit content section form" do
			it "GET content-sections/edit route loads the content-sections/edit page and displays edit content form when user is logged in " do			
				visit "/content-sections/#{@consec.slug}/edit"

				# check correct edit form is displayed
				expect(page.body).to include("<h1>Edit #{@consec.name}</h1>")
				expect(page.body).to include('<form id="edit-content-form"')
				expect(page.body).to include('method="post" action="/content-sections/test-content1"')
				expect(page.body).to include('name="_method" value="patch"')

				# check edit form fields are prefilled with correct existing object info
				expect(find_field("name").value).to eq("#{@consec.name}")
				expect(find_field("css_class").value).to eq("#{@consec.css_class}")
				expect(find_field("page_location").value).to eq @consec.page_location
				expect(find_field("headline").value).to eq("#{@consec.headline}")
				expect(find_field(:body_copy).value).to eq("#{@consec.body_copy}")
				expect(find_field(:link_url).value).to eq("#{@consec.link_url}")
				expect(find_field(:link_text).value).to eq("#{@consec.link_text}")
			end
			
			it "POST content-sections/edit route lets a user enter info to update an existing content section then loads admin/content page upon success" do
				update_consec_info = {name: "update content1", css_class: "text-box", page_location: 3, headline: "HL for update content1", body_copy: "Body copy for update content1.", link_url: "https://www.example3.com", link_text: "example3"}
				visit "/content-sections/#{@consec.slug}/edit"
				
				fill_in :name, :with => "#{update_consec_info[:name]}"
				fill_in :css_class, :with => "#{update_consec_info[:css_class]}"
				fill_in :page_location, :with => update_consec_info[:page_location]
				fill_in :headline, :with => "#{update_consec_info[:headline]}"
				fill_in :body_copy, :with => "#{update_consec_info[:body_copy]}"
				fill_in :link_url, :with => "#{update_consec_info[:link_url]}"
				fill_in :link_text, :with => "#{update_consec_info[:link_text]}"				
				click_button "Update Content Section"

				# check content section updated correctly
				test_consec = ContentSection.find(@consec.id)
				expect(test_consec.name).to eq(update_consec_info[:name])
				expect(test_consec.css_class).to eq(update_consec_info[:css_class])
				expect(test_consec.page_location).to eq update_consec_info[:page_location]
				expect(test_consec.headline).to eq(update_consec_info[:headline])
				expect(test_consec.body_copy).to eq(update_consec_info[:body_copy])
				expect(test_consec.link_url).to eq(update_consec_info[:link_url])
				expect(test_consec.link_text).to eq(update_consec_info[:link_text])

				# check redirect (these should be good)
				expect(page.body).to include("<h1>Content Management</h1>")
				expect(page.body).to include('<nav id="admin">')
				expect(page.body).to include('<a href="/content-sections/new"')
			end
		end

		describe "won't update content section if validated fields are blank" do
			it "POST content-sections/edit route won't update content section if name field is left blank" do
				update_consec_info = {name: "update content1", css_class: "text-box", page_location: 3, headline: "HL for update content1", body_copy: "Body copy for update content1.", link_url: "https://www.example3.com", link_text: "example3"}
				visit "/content-sections/#{@consec.slug}/edit"
				check = @consec.name
				
				# fill in form without name
				fill_in :name, :with => ""
				fill_in :css_class, :with => "#{update_consec_info[:css_class]}"
				fill_in :page_location, :with => update_consec_info[:page_location]
				fill_in :headline, :with => "#{update_consec_info[:headline]}"
				fill_in :body_copy, :with => "#{update_consec_info[:body_copy]}"
				fill_in :link_url, :with => "#{update_consec_info[:link_url]}"
				fill_in :link_text, :with => "#{update_consec_info[:link_text]}"				
				click_button "Update Content Section"
				
				# expect name to be unchanged
				test_consec = ContentSection.find(@consec.id)
				expect(test_consec.name).to eq(check)
				
				# expect info from content-sections/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_consec.name}</h1>")
				expect(page.body).to include('<form id="edit-content-form"')
			end
		end

		describe "won't update content section if validated fields are bad" do
			it "POST content-sections/edit route won't update content section if name is same as other content section" do
				consec2_info = {name: "test content2", css_class: "text-box", page_location: 4, headline: "HL for test content2", body_copy: "Body copy for test content2.", link_url: "https://www.example4.com", link_text: "example4"}
				consec2 = ContentSection.create(consec2_info)
				update_consec_info = {name: "update content1", css_class: "text-box", page_location: 3, headline: "HL for update content1", body_copy: "Body copy for update content1.", link_url: "https://www.example3.com", link_text: "example3"}
				
				visit "/content-sections/#{@consec.slug}/edit"
				check = @consec.name

				# fill in form with duplicated name
				fill_in :name, :with => "test content2"
				fill_in :css_class, :with => "#{update_consec_info[:css_class]}"
				fill_in :page_location, :with => update_consec_info[:page_location]
				fill_in :headline, :with => "#{update_consec_info[:headline]}"
				fill_in :body_copy, :with => "#{update_consec_info[:body_copy]}"
				fill_in :link_url, :with => "#{update_consec_info[:link_url]}"
				fill_in :link_text, :with => "#{update_consec_info[:link_text]}"				
				click_button "Update Content Section"

				# expect name to be unchanged
				test_consec = ContentSection.find(@consec.id)
				expect(test_consec.name).to eq(check)
				
				# expect info from content-sections/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_consec.name}</h1>")
				expect(page.body).to include('<form id="edit-content-form"')
			end

			it "POST content-sections/edit route won't update content section if page_location is same as other content section" do
				consec2_info = {name: "test content2", css_class: "text-box", page_location: 4, headline: "HL for test content2", body_copy: "Body copy for test content2.", link_url: "https://www.example4.com", link_text: "example4"}
				consec2 = ContentSection.create(consec2_info)
				update_consec_info = {name: "update content1", css_class: "text-box", page_location: 3, headline: "HL for update content1", body_copy: "Body copy for update content1.", link_url: "https://www.example3.com", link_text: "example3"}
				
				visit "/content-sections/#{@consec.slug}/edit"
				check = @consec.page_location

				# fill in form with duplicated page_location
				fill_in :name, :with => "#{update_consec_info[:name]}"
				fill_in :css_class, :with => "#{update_consec_info[:css_class]}"
				fill_in :page_location, :with => 4
				fill_in :headline, :with => "#{update_consec_info[:headline]}"
				fill_in :body_copy, :with => "#{update_consec_info[:body_copy]}"
				fill_in :link_url, :with => "#{update_consec_info[:link_url]}"
				fill_in :link_text, :with => "#{update_consec_info[:link_text]}"				
				click_button "Update Content Section"

				# expect page_location to be unchanged
				test_consec = ContentSection.find(@consec.id)
				expect(test_consec.page_location).to eq check
				
				# expect info from content-sections/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_consec.name}</h1>")
				expect(page.body).to include('<form id="edit-content-form"')
			end

			it "POST content-sections/edit route won't update content section if page_location isn't a number" do
				update_consec_info = {name: "update content1", css_class: "text-box", page_location: 3, headline: "HL for update content1", body_copy: "Body copy for update content1.", link_url: "https://www.example3.com", link_text: "example3"}
				visit "/content-sections/#{@consec.slug}/edit"
				check = @consec.page_location

				# fill in form with bad page_location
				fill_in :name, :with => "#{update_consec_info[:name]}"
				fill_in :css_class, :with => "#{update_consec_info[:css_class]}"
				fill_in :page_location, :with => "three"
				fill_in :headline, :with => "#{update_consec_info[:headline]}"
				fill_in :body_copy, :with => "#{update_consec_info[:body_copy]}"
				fill_in :link_url, :with => "#{update_consec_info[:link_url]}"
				fill_in :link_text, :with => "#{update_consec_info[:link_text]}"				
				click_button "Update Content Section"

				# expect page_location to be unchanged
				test_consec = ContentSection.find(@consec.id)
				expect(test_consec.page_location).to eq check
				
				# expect info from content-sections/edit page after reload
				expect(page.body).to include("<h1>Edit #{test_consec.name}</h1>")
				expect(page.body).to include('<form id="edit-content-form"')
			end

			it "POST content-sections/edit route will update content section if page_location is blank (redirects to admin/content instead)" do
				update_consec_info = {name: "update content1", css_class: "text-box", page_location: 3, headline: "HL for update content1", body_copy: "Body copy for update content1.", link_url: "https://www.example3.com", link_text: "example3"}
				visit "/content-sections/#{@consec.slug}/edit"

				# fill in form with blank page_location
				fill_in :name, :with => "#{update_consec_info[:name]}"
				fill_in :css_class, :with => "#{update_consec_info[:css_class]}"
				fill_in :page_location, :with => ""
				fill_in :headline, :with => "#{update_consec_info[:headline]}"
				fill_in :body_copy, :with => "#{update_consec_info[:body_copy]}"
				fill_in :link_url, :with => "#{update_consec_info[:link_url]}"
				fill_in :link_text, :with => "#{update_consec_info[:link_text]}"				
				click_button "Update Content Section"

				# expect page_location to be unchanged
				test_consec = ContentSection.find(@consec.id)
				expect(test_consec.page_location.blank?).to be true				
				
				# expect info from content-sections/edit page after reload
				expect(page.body).to include("<h1>Content Management</h1>")
				expect(page.body).to include('<nav id="admin">')
				expect(page.body).to include('<a href="/content-sections/new"')
			end
			
		end

		# it "POST Route displays the appropriate flash message upon redirect" do
		# 	# think I can test the display in only processing routes no in every get
		# 	# visit "/content-sections/#{@consec.slug}/edit"
		# end
	end

	# delete content section routes ###########################################################
	describe "delete content section route" do
		before do
			visit_admin_and_login_user
		end

		it "DELETE content-sections route deletes only the correct content section then loads admin/content page upon success" do
			consec2_info = {name: "test content2", css_class: "text-box", page_location: 4, headline: "HL for test content2", body_copy: "Body copy for test content2.", link_url: "https://www.example4.com", link_text: "example4"}
			consec2 = ContentSection.create(consec2_info)

			visit '/admin/content'
			click_button "delete-#{consec2.id}"
			
			expect(ContentSection.all.include?(consec2)).to be false
			expect(ContentSection.all.include?(@consec)).to be true
			expect(page.body).to include("<h1>Content Management</h1>")
			expect(page.body).to include('<nav id="admin">')
			expect(page.body).to include('<a href="/content-sections/new"')
		end

		# it "POST Route displays the appropriate flash message upon redirect" do
		# 	# think I can test the display in only processing routes no in every get
		# 	# visit '/admin/content'
		# end
	end
end
