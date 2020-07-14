require 'spec_helper'

describe "AdminController" do
	# need a logged in user for almost all of these
	# need to log the user out for some


	# controller tests ###########################################################

	describe "Admin home routes" do
		describe "admin route" do		
			it "loads the login page and displays login form when user is not logged in" do
				# visit '/admin'
			end		
			
			it "loads the admin/index page when the user is logged in" do
				# visit '/admin'
			end
			
			it "admin/index page links to the admin/users, admin/content and admin/social pages" do
				# visit '/admin'
			end
		end
		
		describe "POST login route" do
			it "lets a user enter their login info and logs them in" do
				# visit '/admin'
			end

			it "won't let an unregistered user log in" do
				# visit '/admin'
			end

			it "loads the admin page after logging a user in" do
				# visit '/admin'
			end

			# it "POST Route displays the appropriate flash message upon redirect" do
			#	# think I can test the display in only processing routes no in every get
			# 	# visit '/admin'
			# end
		end

		describe "GET logout route" do
			# it "logs a user out" do
			it "logs a user out then redirects to the admin page after logging a user out" do			
				# visit '/admin'
			end

			# it "redirects to the admin page after logging a user out" do
			# 	# visit '/admin'
			# end

			# it "displays the appropriate flash message upon redirect" do
			#	# think I can test the display in only processing routes no in every get
			# 	# visit '/admin'
			# end
		end
    end

	describe "Admin User Routes" do
		it "redirects to the admin/login page if user not logged in" do
			# visit '/admin/users'
		end

		it "loads the admin/users page only if a user is logged in" do
			# visit '/admin/users'
		end

		it "admin/users page has a link to add a new user" do
			# visit '/admin/users'
		end
		
		it "admin/users page lists all users and their info" do
			# visit '/admin/users'
		end

		it "each user on admin/users page has links to edit and delete it" do
			# visit '/admin/users'
		end
	end
	
	describe "Admin Content routes" do
		it "redirects to the admin/login page if user not logged in" do
			# visit '/admin/content'
		end

		it "loads the admin/content page only if a user is logged in" do
			# visit '/admin/content'
		end

		it "admin/content page has a link to add a new content_section" do
			# visit '/admin/content'
		end
		
		it "admin/content page lists all content_sections in location order" do
			# visit '/admin/content'
		end

		it "each content_section on admin/content page displays its name, HL, body, link text, last updated" do
			# visit '/admin/content'
		end

		it "each content_section on admin/content page has links to edit and delete it" do
			# visit '/admin/content'
		end
	end
	
	describe "Admin Social routes" do
		describe "overall view" do
			it "redirects to the admin/login page if user not logged in" do
				# visit '/admin/social'
			end
	
			it "loads the admin/social page only if a user is logged in" do
				# visit '/admin/social'
			end
		end


		describe "platforms portion of view" do	
			it "admin/social page has a link to add a new social_platform" do
				# visit '/admin/social'
			end
			
			it "admin/social page lists all social_platforms and their info" do
				# visit '/admin/social'
			end
	
			it "each social_platform on admin/social page has links to edit and delete it" do
				# visit '/admin/social'
			end
		end

		describe "profiles portion of view" do
			it "admin/social page has a link to add a new social_profile" do
				# visit '/admin/social'
			end
			
			it "admin/social page lists all social_profiles and their info" do
				# visit '/admin/social'
			end
	
			it "each social_profile on admin/social page has links to edit and delete it" do
				# visit '/admin/social'
			end
		end
    end



	# helper method tests ########################################################


end