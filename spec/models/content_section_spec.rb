require 'spec_helper'

describe "ContentSection" do        
    # object creation and validation tests #######################################
    describe "can create and save valid instances " do
        it "can instantiate with a name, css_class, page_location, headline, body_copy, link" do
            attrs = {
                name: "test content", 
                css_class: "text-box", 
                page_location: 1, 
                headline: "this is cool content", 
                body_copy: "Maybe it is cool and maybe it is not. I will let you decide.", 
                link: "https://www.example.com"
            }

            con_sec = ContentSection.create(attrs)
            
            expect(con_sec.valid?).to be true
            expect(con_sec).to be_an_instance_of(ContentSection)

            expect(con_sec.name).to eq("test content")
            expect(con_sec.css_class).to eq("text-box")
            expect(con_sec.page_location).to eq 1
            expect(con_sec.headline).to eq("this is cool content")
            expect(con_sec.body_copy).to eq("Maybe it is cool and maybe it is not. I will let you decide.")
            expect(con_sec.link).to eq("https://www.example.com")
        end
            
        it "can instantiate with only a name" do
            con_sec = ContentSection.create(name: "another test")
            
            expect(con_sec.valid?).to be true
            expect(con_sec).to be_an_instance_of(ContentSection)
        end
    end
    
    describe "has a required, unique name (case insensitive) and provides correct error message when invalid" do
        it "won't instantiate without a name" do
            no_name = ContentSection.create(name: "")
            
            expect(no_name.save).to be false
            expect(no_name.errors.messages[:name]).to include("You must provide a name.")
        end
        
        it "won't instantiate when name is same as other instance (case insensitive)" do
            valid_instance = ContentSection.create(name: "name test")
            same_name = ContentSection.create(name: "name test")
            same_name_cap = ContentSection.create(name: "Name Test")

            expect(same_name.save).to be false
            expect(same_name.errors.messages[:name]).to include("That name is already used. Please provide another.")
            expect(same_name_cap.save).to be false
            expect(same_name_cap.errors.messages[:name]).to include("That name is already used. Please provide another.")
        end
    end

    describe "can have a unique page_location that is an integer and provides correct error message when invalid" do
        it "won't instantiate when location is same as other instance" do
            valid_instance = ContentSection.create(name: "test content", page_location: 1)
            same_location = ContentSection.create(name: "dupe location", page_location: 1)
            
            expect(same_location.save).to be false
            expect(same_location.errors.messages[:page_location]).to include("You already have content in that location. Please choose another.")
        end

        it "won't instantiate when page_location is not an integer" do            
            valid_instance = ContentSection.create(name: "test content", page_location: 1)
            not_num = ContentSection.create(name: "not number", page_location: "five")
            
            expect(not_num.save).to be false
            expect(not_num.errors.messages[:page_location]).to include("Page location must be a whole number.")
        end
    end
    
    # helper method tests ########################################################
    describe "all helper methods work correctly" do
        # tests #absolute_link? method
        it "can tell if the link is absolute or relative" do
            abs_http_link_1 = ContentSection.create(name: "absolute link", link: "https://example.com")
            abs_http_link_2 = ContentSection.create(name: "absolute link", link: "http://example.com")
            abs_http_www_link_1 = ContentSection.create(name: "absolute link", link: "https://www.example.com")
            abs_http_www_link_2 = ContentSection.create(name: "absolute link", link: "http://www.example.com")
            abs_www_link = ContentSection.create(name: "absolute link", link: "www.example.com")
            relative_link = ContentSection.create(name: "relative link", link: "/example")
            
            expect(abs_http_link_1.absolute_link?).to be true
            expect(abs_http_link_2.absolute_link?).to be true
            expect(abs_http_www_link_1.absolute_link?).to be true
            expect(abs_http_www_link_2.absolute_link?).to be true
            expect(abs_www_link.absolute_link?).to be true
            expect(relative_link.absolute_link?).to be false
        end
        
        # tests #formatted_date method
        it "can return only the properly formatted date of when the object was created and updated" do
            date_test = ContentSection.create(name: "date test")
            
            expect(date_test.formatted_date(date_test.created_at)).to match(/\d\d\/\d\d\/\d\d\d\d/)
            expect(date_test.formatted_date(date_test.updated_at)).to match(/\d\d\/\d\d\/\d\d\d\d/)
        end

        # tests #slug method
        it "has a properly created slug" do
            one_word = ContentSection.create(name: "stuff")
            one_word_cap = ContentSection.create(name: "Content")
            multi_word = ContentSection.create(name: "cool stuff and content")
            multi_word_cap = ContentSection.create(name: "cOOl Stuff AND Content")
            crazy_one_word = ContentSection.create(name: "$tu3FF")
            crazy_multi_word = ContentSection.create(name: "cR@z4 $tu3FF")
            
            expect(one_word.slug).to eq("stuff")
            expect(one_word_cap.slug).to eq("content")
            expect(multi_word.slug).to eq("cool-stuff-and-content")
            expect(multi_word_cap.slug).to eq("cool-stuff-and-content")
            expect(crazy_one_word.slug).to eq("tu3ff")
            expect(crazy_multi_word.slug).to eq("crz4-tu3ff")
        end
        
        # tests .find_by_slug method
            # (commenting out to see if needed here, use in other classes if not)
        # it "can be found by its slug" do
        #     con_sec = ContentSection.create(name: "cool stuff and content")
        #     search_result = ContentSection.find_by_slug("cool-stuff-and-content")
        #     expect(search_result).to eq(con_sec)
        # end
    end
end


