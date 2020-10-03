require 'spec_helper'
require 'pry'
describe "AppController" do    
    # template/layout tests ###########################################################
    describe "Layout template" do
        it "loads the homepage with correct site template content, including link to contact page" do
            visit '/'            

            # check header content
            expect(page.body).to include('<h1><a href="/">Mark Stabler</a></h1>')
            expect(page.body).to include('<h2 class="grey-text">Writer of Code, Copy, Poetry</h2>')
            expect(page.body).to include('<div id="header-right" class="social">')
            
            # check footer content (include contact link)
            expect(page.body).to include('<div id="footer-top">')
            expect(page.body).to include('<div id="footer-bottom" class="social">')
            expect(page.body).to include('<a href="/contact">CONTACT</a>')
            expect(page.body).to include("© Stabler Writing Services, LLC")
        end

        it "template loads the correct stylesheet for public pages" do
            visit '/'

            expect(page.body).to include('<link href="/styles/global.css"')
            expect(page.body).to_not include('<link href="/styles/admin.css"')
		    expect(page.body).to include('<link href="/styles/index.css"')
            expect(page.body).to include('<link href="/styles/responsive.css"')
        end

        it "template loads the correct stylesheet for admin pages when logged in" do
            visit_admin_and_login_user
            visit '/admin'

            expect(page.body).to include('<link href="/styles/global.css"')
            expect(page.body).to include('<link href="/styles/admin.css"')
		    expect(page.body).to_not include('<link href="/styles/index.css"')
	        expect(page.body).to include('<link href="/styles/responsive.css"')            
        end
    end

    # home page tests ###########################################################
    describe "Home page" do
        before do
            consec_intro_info = {name: "test intro content", css_class: "intro", page_location: 0, headline: "HL for Intro", body_copy: "Body copy for test for intro", link_url: "https://www.example1.com", link_text: "intro link"}
            consec_vip_hl_info = {name: "test vip headline", css_class: "text-box", page_location: 1, headline: "HL for VIP Headline", body_copy: "Body copy for test for VIP HL - should not appear", link_url: "https://www.example2.com", link_text: "vip link - no show"}
            consec_boxl_info = {name: "test box1 content", css_class: "text-box", page_location: 2, headline: "HL for Box1", body_copy: "Body copy for test for box1", link_url: "https://www.example3.com", link_text: "box1 link"}
            consec_box2_info = {name: "test box2 content", css_class: "text-box", page_location: 3, headline: "HL for Box2", body_copy: "Body copy for test for box2", link_url: "https://www.example4.com", link_text: "box2 link"}
            consec_box3_info = {name: "test box3 content", css_class: "text-box", page_location: 4, headline: "HL for Box3", body_copy: "Body copy for test for box3", link_url: "https://www.example5.com", link_text: "box3 link"}
            consec_bottoml_info = {name: "test bottom1 content", css_class: "text-box bottom-box", page_location: 5, headline: "HL for Bottom1", body_copy: "Body copy for test for Bottom1", link_url: "https://www.example6.com", link_text: "bottom1 link"}
            consec_bottom2_info = {name: "test bottom2 content", css_class: "text-box bottom-box", page_location: 6, headline: "HL for Bottom2", body_copy: "Body copy for test for Bottom2", link_url: "https://www.example7.com", link_text: "bottom2 link"}
            consec_bottom3_info = {name: "test bottom3 content", css_class: "text-box bottom-box", page_location: 7, headline: "HL for Bottom3", body_copy: "Body copy for test for Bottom3", link_url: "https://www.example8.com", link_text: "bottom3 link"}
            @consec_intro = ContentSection.create(consec_intro_info)
            @consec_vip_hl = ContentSection.create(consec_vip_hl_info)
            @consec_boxl = ContentSection.create(consec_boxl_info)
            @consec_box2 = ContentSection.create(consec_box2_info)
            @consec_box3 = ContentSection.create(consec_box3_info)
            @consec_bottoml = ContentSection.create(consec_bottoml_info)
            @consec_bottom2 = ContentSection.create(consec_bottom2_info)
            @consec_bottom3 = ContentSection.create(consec_bottom3_info)
        end

        it "home page can list all content_sections in location order with correct content" do
            visit '/'

            counter = -1 	# this is for checking that list is in proper order
			ContentSection.all.order("page_location ASC").each do |con_sec|
				expect(con_sec.page_location).to eq(counter += 1)
                expect(page.body).to include("#{con_sec.headline}</h")
                if con_sec.page_location != 1
				    expect(page.body).to include("#{con_sec.body_copy}</p>")
                    expect(page.body).to include('<a href="http://'<<"#{con_sec.formatted_link_url}") if con_sec.absolute_link?
                    expect(page.body).to include('<a href="'<<"#{con_sec.formatted_link_url}") if !con_sec.absolute_link?
                    expect(page.body).to include("#{con_sec.link_text}</a>")
                end
			end
        end        

        it "on home page, all content in page_location 1 only displays the headline" do
            visit '/'

            ContentSection.all.order("page_location ASC").each do |con_sec|				
                expect(page.body).to include("#{con_sec.headline}</h")
                if con_sec.page_location == 1
                    expect(page.body).to_not include("#{con_sec.body_copy}</p>")
                    expect(page.body).to_not include('<a href="http://'<<"#{con_sec.formatted_link_url}") if con_sec.absolute_link?
                    expect(page.body).to_not include('<a href="'<<"#{con_sec.formatted_link_url}") if !con_sec.absolute_link?
                    expect(page.body).to_not include("#{con_sec.link_text}</a>")
                end
            end
        end

        it "on home page, all content_sections have correct css_id and css_class" do
            visit '/'

            ContentSection.all.order("page_location ASC").each do |con_sec|
                expect(page.body).to include('id="'<<"#{con_sec.css_id}")
                expect(page.body).to include('class="'<<"#{con_sec.css_class}")
            end
        end

        it "home page won't list any content_sections without a page_location value" do            
            @consec_intro.page_location = ""
            @consec_bottom2.page_location = ""
            @consec_bottom3.page_location = ""
            @consec_intro.save
            @consec_bottom2.save
            @consec_bottom3.save

            visit '/'

            ContentSection.all.order("page_location ASC").each do |con_sec|                
                if con_sec.page_location.blank?
                    expect(page.body).to_not include("#{con_sec.headline}</h")
                    expect(page.body).to_not include("#{con_sec.body_copy}</p>")
                    expect(page.body).to_not include('<a href="http://'<<"#{con_sec.formatted_link_url}") if con_sec.absolute_link?
                    expect(page.body).to_not include('<a href="'<<"#{con_sec.formatted_link_url}") if !con_sec.absolute_link?
                    expect(page.body).to_not include("#{con_sec.link_text}</a>")
                end
            end
        end
    end

    describe "Contact page" do
        it "loads the contact page and displays the contact form" do
            visit '/contact'

            expect(page.body).to include("<h1>Contact</h1>")
            expect(page.body).to include('<form id="contact-form"')
            expect(page.body).to include('method="post" action="/contact"')
            expect(page).to have_field(:first_name)
            expect(page).to have_field(:last_name)
            expect(page).to have_field(:email)
            expect(page).to have_field(:subject)
            expect(page).to have_field(:body)
        end   
    
        it "lets a user create and send an email to the correct address, then reloads the page" do
            email_info = {first_name: "test", last_name: "sender", email: "testsender1@example.com", subject: "I want to hire your", body: "please work with me"}

            visit '/contact'

            fill_in :first_name, :with => "#{email_info[:first_name]}"
            fill_in :last_name, :with => "#{email_info[:last_name]}"
            fill_in :email, :with => "#{email_info[:email]}"
            fill_in :subject, :with => "#{email_info[:subject]}"
            fill_in :body, :with => "#{email_info[:body]}"
            click_button "Send"

            expect(params[:email][:first_name]).to eq("test")
            expect(params[:email][:last_name]).to eq("sender")
            expect(params[:email][:email]).to eq("testsender1@example.com")
            expect(params[:email][:subject]).to eq("I want to hire your")
            expect(params[:email][:body]).to eq("please work with me")
            
            # # need to verify email address sent to and how info is transfered for mailto form

            # expect(page).to have_current_path("/contact")
        end

        # it "POST Route displays the appropriate flash message upon redirect" do
		# 	# think I can test the display in only processing routes no in every get
		# 	# visit '/contact'
		# end
    end
end