require 'spec_helper'

describe "AppController" do    
	# controller tests ###########################################################
	# add your describe statements to group if needed

	# it "can [descriptiong of what instance should be able to do]" do
		# setup tests
		# create test value

		# expect(test value).to eq("known true value")
	# end

    # repeate for each functionality to be tested
    
    describe "Home page" do
        it "loads the homepage" do
            # visit '/'

            # expect(page.status_code).to eq(200)
            # expect(page.body).to include("")
        end

        it "displays all content_sections" do
            # visit '/'

            # ContentSection.all.count
            # expect number of sections to equal the count
            # expect(page.body).to include("")
        end

        it "links to contact page" do
            # visit '/'

            # expect(page.body).to include("")
        end
    end

    describe "Contact page" do
        it "loads the contact page and displays the contact form" do
            visit '/contact'
            
            # expect(page.status_code).to eq(200)
            # expect(page.body).to include("")
        end
    
        it "lets a user create and send an email to the correct address, then reloads the page" do
            # visit '/contact'
            
            # fill_in :first_name, :with => "input value"
            # fill_in :last_name, :with => "input value"
            # fill_in :email, :with => "input value"
            # fill_in :subject, :with => "input value"
            # fill_in :message, :with => "input value"
            # click_button "Submit"            

            # expect(params[:first_name]).to eq("input value")
            # expect(params[:last_name]).to eq("input value")
            # expect(params[:email]).to eq("input value")
            # expect(params[:subject]).to eq("input value")
            # expect(params[:message]).to eq("input value")
            # expect(params[:message]).to eq("input value")
            
            # # need to verify email address sent to and how info is transfered for mailto form

            # expect(page).to have_current_path("/contact")
        end

        # it "POST Route displays the appropriate flash message upon redirect" do
		# 	# think I can test the display in only processing routes no in every get
		# 	# visit '/contact'
		# end
    end


	# helper method tests ########################################################


end