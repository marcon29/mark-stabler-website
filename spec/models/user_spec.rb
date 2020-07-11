require 'spec_helper'

describe "User" do        
    # object creation and validation tests #######################################

    # don't forget to add your "do"
    
    it "can instantiate with a first_name, last_name, email, username" do
        # attrs = {
        #     name: "test content", 
        #     css_class: "text-box", 
        #     page_location: 1, 
        #     headline: "this is cool content", 
        #     body_copy: "Maybe it is cool and maybe it is not. I will let you decide.", 
        #     link: "https://www.makstabler.com"
        # }

        # con_sec = ContentSection.create(attrs)
        
        # expect(con_sec.valid?).to be true
        # expect(con_sec).to be_an_instance_of(ContentSection)

        # expect(con_sec.name).to eq("test content")
        # expect(con_sec.css_class).to eq("text-box")
        # expect(con_sec.page_location).to eq 1
        # expect(con_sec.headline).to eq("this is cool content")
        # expect(con_sec.body_copy).to eq("Maybe it is cool and maybe it is not. I will let you decide.")
        # expect(con_sec.link).to eq("https://www.makstabler.com")
    end

    describe "has a required first and last name and provides correct error message when invalid" do
        it "won't instantiate without a first name" do
            # no_name = ContentSection.create(name: "")
            
            # expect(no_name.save).to be false
            # expect(no_name.errors.messages[:name]).to include("You must provide a name.")
        end

        it "won't instantiate without a last name" do
            # no_name = ContentSection.create(name: "")
            
            # expect(no_name.save).to be false
            # expect(no_name.errors.messages[:name]).to include("You must provide a name.")
        end
    end
    
    describe "has a required, unique username (case insensitive) and provides correct error message when invalid" do
        it "won't instantiate without a username" do
            # no_name = ContentSection.create(name: "")
            
            # expect(no_name.save).to be false
            # expect(no_name.errors.messages[:name]).to include("You must provide a name.")
        end
        
        it "won't instantiate when username is same as other instance (case insensitive)" do
            # valid_instance = ContentSection.create(name: "name test")
            # same_name = ContentSection.create(name: "name test")
            # same_name_cap = ContentSection.create(name: "Name Test")

            # expect(same_name.save).to be false
            # expect(same_name.errors.messages[:name]).to include("That name is already used. Please provide another.")
            # expect(same_name_cap.save).to be false
            # expect(same_name_cap.errors.messages[:name]).to include("That name is already used. Please provide another.")
        end

        it "won't instantiate when username contains spaces or special characters" do
            # valid_instance = ContentSection.create(name: "name test")
            # same_name = ContentSection.create(name: "name test")
            # same_name_cap = ContentSection.create(name: "Name Test")

            # expect(same_name.save).to be false
            # expect(same_name.errors.messages[:name]).to include("That name is already used. Please provide another.")
            # expect(same_name_cap.save).to be false
            # expect(same_name_cap.errors.messages[:name]).to include("That name is already used. Please provide another.")
        end
    end

    describe "has a required, unique username (case insensitive) and provides correct error message when invalid" do
        it "won't instantiate without a username" do
            # no_name = ContentSection.create(name: "")
            
            # expect(no_name.save).to be false
            # expect(no_name.errors.messages[:name]).to include("You must provide a name.")
        end
        
        it "won't instantiate when username is same as other instance (case insensitive)" do
            # valid_instance = ContentSection.create(name: "name test")
            # same_name = ContentSection.create(name: "name test")
            # same_name_cap = ContentSection.create(name: "Name Test")

            # expect(same_name.save).to be false
            # expect(same_name.errors.messages[:name]).to include("That name is already used. Please provide another.")
            # expect(same_name_cap.save).to be false
            # expect(same_name_cap.errors.messages[:name]).to include("That name is already used. Please provide another.")
        end

        it "won't instantiate when username contains spaces or special characters" do
            # valid_instance = ContentSection.create(name: "name test")
            # same_name = ContentSection.create(name: "name test")
            # same_name_cap = ContentSection.create(name: "Name Test")

            # expect(same_name.save).to be false
            # expect(same_name.errors.messages[:name]).to include("That name is already used. Please provide another.")
            # expect(same_name_cap.save).to be false
            # expect(same_name_cap.errors.messages[:name]).to include("That name is already used. Please provide another.")
        end
    end


    # helper method tests ########################################################
    # tests .full_name method    
    it "can create a properly formatted full name from user's first and last name" do
        # con_sec = ContentSection.create(name: "cool stuff and content")
        # search_result = ContentSection.find_by_slug("cool-stuff-and-content")
        # expect(search_result).to eq(con_sec)
    end
    
    # tests #slug method
    it "has a properly created slug" do
        # one_word = ContentSection.create(name: "stuff")
        # one_word_cap = ContentSection.create(name: "Content")
        # multi_word = ContentSection.create(name: "cool stuff and content")
        # multi_word_cap = ContentSection.create(name: "cOOl Stuff AND Content")
        # crazy_one_word = ContentSection.create(name: "$tu3FF")
        # crazy_multi_word = ContentSection.create(name: "cR@z4 $tu3FF")
        
        # expect(one_word.slug).to eq("stuff")
        # expect(one_word_cap.slug).to eq("content")
        # expect(multi_word.slug).to eq("cool-stuff-and-content")
        # expect(multi_word_cap.slug).to eq("cool-stuff-and-content")
        # expect(crazy_one_word.slug).to eq("tu3ff")
        # expect(crazy_multi_word.slug).to eq("crz4-tu3ff")
    end
    
    # tests .find_by_slug method
    it "can be found by its slug" do
    #     con_sec = ContentSection.create(name: "cool stuff and content")
    #     search_result = ContentSection.find_by_slug("cool-stuff-and-content")
    #     expect(search_result).to eq(con_sec)
    end

end