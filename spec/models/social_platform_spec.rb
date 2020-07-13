require 'spec_helper'

require 'pry'

describe "SocialPlatform" do        
    # object creation and validation tests #######################################
    describe "can create and save valid instances " do
        it "can instantiate with a name, base url, and image file name" do
            valid_attrs = {name: "platform name", base_url: "https://www.example.com", image_file_name: "icon.png"}
            platform = SocialPlatform.create(valid_attrs)
            
            expect(platform.valid?).to be true
            expect(platform).to be_an_instance_of(SocialPlatform)
            expect(platform.name).to eq("platform name")
            expect(platform.base_url).to eq("www.example.com/")
            expect(platform.image_file_name).to eq("icon.png")
        end
    end

    describe "has a required, unique name (case insensitive) and provides correct error message when invalid" do
        it "won't instantiate without a name" do
            test_attrs = {name: "", base_url: "https://www.example.com", image_file_name: "icon.png"}
            no_name = SocialPlatform.create(test_attrs)
            
            expect(no_name.save).to be false
            expect(no_name.errors.messages[:name]).to include("You must provide a name.")
        end
        
        it "won't instantiate when name is same as other instance (case insensitive)" do
            valid_attrs = {name: "platform name", base_url: "https://www.example1.com", image_file_name: "icon1.png"}
            test_attrs = {name: "platform name", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
            test_attrs_cap = {name: "Platform Name", base_url: "https://www.example3.com", image_file_name: "icon3.png"}
            
            valid_instance = SocialPlatform.create(valid_attrs)
            same_name = SocialPlatform.create(test_attrs)
            same_name_cap = SocialPlatform.create(test_attrs_cap)

            expect(same_name.save).to be false
            expect(same_name.errors.messages[:name]).to include("That platform already exists. Please provide another.")
            expect(same_name_cap.save).to be false
            expect(same_name_cap.errors.messages[:name]).to include("That platform already exists. Please provide another.")
        end
    end

    describe "has a required, unique base_url (case insensitive) that matches standard url text patterns and provides correct error message when invalid" do
        it "won't instantiate without an base_url" do
            test_attrs = {name: "platform name", base_url: "", image_file_name: "icon.png"}
            no_base_url = SocialPlatform.create(test_attrs)
            
            expect(no_base_url.save).to be false
            expect(no_base_url.errors.messages[:base_url]).to include("You must provide the base URL.")
        end
        
        it "won't instantiate when base_url is same as other instance (case insensitive)" do
            valid_attrs = {name: "platform1 name", base_url: "https://www.example.com", image_file_name: "icon1.png"}
            test_attrs = {name: "platform2 name", base_url: "https://www.example.com", image_file_name: "icon2.png"}
            test_attrs_cap = {name: "platform3 name", base_url: "https://WWW.Example.Com", image_file_name: "icon3.png"}
            
            valid_instance = SocialPlatform.create(valid_attrs)
            same_base_url = SocialPlatform.create(test_attrs)
            same_base_url_cap = SocialPlatform.create(test_attrs_cap)

            expect(same_base_url.save).to be false
            expect(same_base_url.errors.messages[:base_url]).to include("That URL is already used for another platform. Please provide another.")
            expect(same_base_url_cap.save).to be false
            expect(same_base_url_cap.errors.messages[:base_url]).to include("That URL is already used for another platform. Please provide another.")
        end

        it "won't instantiate when base_url doesn't follow standard base_url text pattern" do
            # can only use letters, numbers, and hyphens; no hyphens at beginning or end of domain; must have TLD; case insensitive (covered above)
            # base_url will be formatted before validation to always be valid

            extra_dot1_attrs = {name: "platform1 name", base_url: "https://www.example..com", image_file_name: "icon1.png"}
            extra_dot2_attrs = {name: "platform2 name", base_url: "https://www..example.com", image_file_name: "icon2.png"}
            starting_hyphen_attrs = {name: "platform3 name", base_url: "https://www.-example.com", image_file_name: "icon3.png"}
            ending_hyphen_attrs = {name: "platform4 name", base_url: "https://www.example-.com", image_file_name: "icon4.png"}
            char_attrs = {name: "platform5 name", base_url: "https://www.e%@mple.com", image_file_name: "icon5.png"}
            punc_attrs = {name: "platform6 name", base_url: "https://www.examp!e.com", image_file_name: "icon6.png"}
            no_tld_attrs = {name: "platform7 name", base_url: "https://www.example", image_file_name: "icon7.png"}
            short_tld_attrs = {name: "platform8 name", base_url: "https://www.example.c", image_file_name: "icon8.png"}
            long_tld_attrs = {name: "platform9 name", base_url: "https://www.example.comm", image_file_name: "icon9.png"}
            bad_tld_attrs = {name: "platform10 name", base_url: "https://www.example.c2m", image_file_name: "icon10.png"}
            no_domain_attrs = {name: "platform11 name", base_url: "https://www.com", image_file_name: "icon11.png"}
            has_spaces_attrs = {name: "platform12 name", base_url: "https://www.ex ample.com", image_file_name: "icon12.png"}

            extra_dot1 = SocialPlatform.create(extra_dot1_attrs)
            extra_dot2 = SocialPlatform.create(extra_dot2_attrs)
            starting_hyphen = SocialPlatform.create(starting_hyphen_attrs)
            ending_hyphen = SocialPlatform.create(ending_hyphen_attrs)
            char = SocialPlatform.create(char_attrs)
            punc = SocialPlatform.create(punc_attrs)
            no_tld = SocialPlatform.create(no_tld_attrs)
            short_tld = SocialPlatform.create(short_tld_attrs)
            long_tld = SocialPlatform.create(long_tld_attrs)
            bad_tld = SocialPlatform.create(bad_tld_attrs)
            no_domain = SocialPlatform.create(no_domain_attrs)
            has_spaces = SocialPlatform.create(has_spaces_attrs)

            expect(extra_dot1.save).to be false
            expect(extra_dot1.errors.messages[:base_url]).to include("That URL doesn't look valid. Please provide another.")
            expect(extra_dot2.save).to be false
            expect(extra_dot2.errors.messages[:base_url]).to include("That URL doesn't look valid. Please provide another.")
            expect(starting_hyphen.save).to be false
            expect(starting_hyphen.errors.messages[:base_url]).to include("That URL doesn't look valid. Please provide another.")
            expect(ending_hyphen.save).to be false
            expect(ending_hyphen.errors.messages[:base_url]).to include("That URL doesn't look valid. Please provide another.")
            expect(char.save).to be false
            expect(char.errors.messages[:base_url]).to include("That URL doesn't look valid. Please provide another.")
            expect(punc.save).to be false
            expect(punc.errors.messages[:base_url]).to include("That URL doesn't look valid. Please provide another.")
            expect(no_tld.save).to be false
            expect(no_tld.errors.messages[:base_url]).to include("That URL doesn't look valid. Please provide another.")
            expect(short_tld.save).to be false
            expect(short_tld.errors.messages[:base_url]).to include("That URL doesn't look valid. Please provide another.")
            expect(long_tld.save).to be false
            expect(long_tld.errors.messages[:base_url]).to include("That URL doesn't look valid. Please provide another.")
            expect(bad_tld.save).to be false
            expect(bad_tld.errors.messages[:base_url]).to include("That URL doesn't look valid. Please provide another.")
            expect(no_domain.save).to be false
            expect(no_domain.errors.messages[:base_url]).to include("That URL doesn't look valid. Please provide another.")
            expect(has_spaces.save).to be false
            expect(has_spaces.errors.messages[:base_url]).to include("That URL doesn't look valid. Please provide another.")
        end

        it "will instantiate with a variety of possible base_url user entries" do
            # http and https, w/ or w/o www., w/ or w/o resources

            full_attrs = {name: "platform1 name", base_url: "http://www.example1.com", image_file_name: "icon1.png"}
            full_secure_attrs = {name: "platform2 name", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
            trailing_slash_attrs = {name: "platform3 name", base_url: "https://www.example3.com/", image_file_name: "icon3.png"}
            no_www_attrs = {name: "platform4 name", base_url: "http://example4.com", image_file_name: "icon4.png"}
            no_www_secure_attrs = {name: "platform5 name", base_url: "https://example5.com", image_file_name: "icon5.png"}
            www_only_attrs = {name: "platform6 name", base_url: "www.example6.com", image_file_name: "icon6.png"}
            domain_only_attrs = {name: "platform7 name", base_url: "example7.com", image_file_name: "icon7.png"}
            resources_attrs = {name: "platform8 name", base_url: "http://www.example8.com/asdfadsf/asdfasdf", image_file_name: "icon8.png"}
            resources_trailing_slash_attrs = {name: "platform9 name", base_url: "http://www.example9.com/asdfasdf/", image_file_name: "icon9.png"}

            full = SocialPlatform.create(full_attrs)
            full_secure = SocialPlatform.create(full_secure_attrs)
            trailing_slash = SocialPlatform.create(trailing_slash_attrs)
            no_www = SocialPlatform.create(no_www_attrs)
            no_www_secure = SocialPlatform.create(no_www_secure_attrs)
            www_only = SocialPlatform.create(www_only_attrs)
            domain_only = SocialPlatform.create(domain_only_attrs)
            resources = SocialPlatform.create(resources_attrs)
            resources_trailing_slash = SocialPlatform.create(resources_trailing_slash_attrs)

            expect(full.save).to be true
            expect(full_secure.save).to be true
            expect(trailing_slash.save).to be true
            expect(no_www.save).to be true
            expect(no_www_secure.save).to be true
            expect(www_only.save).to be true
            expect(domain_only.save).to be true
            expect(resources.save).to be true
            expect(resources_trailing_slash.save).to be true
        end
    end

    describe "has a required, unique image_file_name (case insensitive) that restricts files to certain types and provides correct error message when invalid" do
        it "won't instantiate without an image_file_name" do
            test_attrs = {name: "platform name", base_url: "https://www.example.com", image_file_name: ""}
            no_image_file_name = SocialPlatform.create(test_attrs)
            
            expect(no_image_file_name.save).to be false
            expect(no_image_file_name.errors.messages[:image_file_name]).to include("You must provide the image file name.")
        end
        
        it "won't instantiate when image_file_name is same as other instance (case insensitive)" do
            valid_attrs = {name: "platform1 name", base_url: "https://www.example1.com", image_file_name: "icon.png"}
            test_attrs = {name: "platform2 name", base_url: "https://www.example2.com", image_file_name: "icon.png"}
            test_attrs_cap = {name: "platform3 name", base_url: "https://www.example3.com", image_file_name: "IcoN.png"}
            
            valid_instance = SocialPlatform.create(valid_attrs)
            same_image_file_name = SocialPlatform.create(test_attrs)
            same_image_file_name_cap = SocialPlatform.create(test_attrs_cap)

            expect(same_image_file_name.save).to be false
            expect(same_image_file_name.errors.messages[:image_file_name]).to include("That image file already exists. Please provide another.")
            expect(same_image_file_name_cap.save).to be false
            expect(same_image_file_name_cap.errors.messages[:image_file_name]).to include("That image file already exists. Please provide another.")
        end

        it "will only instantiate when image_file_name has correct file extension" do
            # file extension must be one of: .jpeg .jpg .png .svg

            jpeg_attrs = {name: "platform1 name", base_url: "http://www.example1.com", image_file_name: "icon1.jpeg"}
            jpg_attrs = {name: "platform2 name", base_url: "http://www.example2.com", image_file_name: "icon1.jpg"}
            png_attrs = {name: "platform3 name", base_url: "http://www.example3.com", image_file_name: "icon1.png"}
            svg_attrs = {name: "platform4 name", base_url: "http://www.example4.com", image_file_name: "icon1.svg"}
            bad_ext_attrs = {name: "platform5 name", base_url: "http://www.example5.com", image_file_name: "icon1.xyz"}

            jpeg = SocialPlatform.create(jpeg_attrs)
            jpg = SocialPlatform.create(jpg_attrs)
            png = SocialPlatform.create(png_attrs)
            svg = SocialPlatform.create(svg_attrs)
            bad_ext= SocialPlatform.create(bad_ext_attrs)

            expect(jpeg.save).to be true
            expect(jpg.save).to be true
            expect(png.save).to be true
            expect(svg.save).to be true
            expect(bad_ext.save).to be false
            expect(bad_ext.errors.messages[:image_file_name]).to include("Only .jpeg, .jpg, .png, or .svg files are allowed.")
        end
    end
    

    # model association tests ####################################################
    describe "works with assoicated models correctly" do
        it "has many social_profiles" do
            valid_attrs = {name: "platform", base_url: "https://www.example.com", image_file_name: "icon.png"}
            profile1_attrs = {name: "profile one", handle: "profileone", notes: "notes for profile one"}
            profile2_attrs = {name: "profile two", handle: "profiletwo", notes: "notes for profile two"}

            platform = SocialPlatform.create(valid_attrs)
            profile1 = SocialProfile.create(profile1_attrs)
            profile2 = SocialProfile.create(profile2_attrs)

            # if need to add .save (or assign the other way around) - update the delete test below also
            platform.social_profiles << profile1
            platform.social_profiles << profile2

            expect(platform.social_profiles).to include(profile1)
            expect(platform.social_profiles).to include(profile2)
        end

        it "will also delete any associated social_profiles if itself is deleted" do
            valid_attrs = {name: "platform", base_url: "https://www.example.com", image_file_name: "icon.png"}
            profile1_attrs = {name: "profile one", handle: "profileone", notes: "notes for profile one"}
            profile2_attrs = {name: "profile two", handle: "profiletwo", notes: "notes for profile two"}

            platform = SocialPlatform.create(valid_attrs)
            profile1 = SocialProfile.create(profile1_attrs)
            profile2 = SocialProfile.create(profile2_attrs)

            platform.social_profiles << profile1
            platform.social_profiles << profile2

            platform.destroy

            expect(SocialProfile.all.include?(profile1)).to be false
            expect(SocialProfile.all.include?(profile2)).to be false
        end
    end


    # helper method tests ########################################################
    describe "all helper methods work correctly" do

        # tests format_base_url method
        it "can take a user's url entry and format it to set up correct link text for view" do
            full_attrs = {name: "platform1 name", base_url: "http://www.facebook.com", image_file_name: "icon1.png"}
            full_secure_attrs = {name: "platform2 name", base_url: "https://www.facebook.com", image_file_name: "icon2.png"}
            trailing_slash_attrs = {name: "platform3 name", base_url: "https://www.facebook.com/", image_file_name: "icon3.png"}
            no_www_attrs = {name: "platform4 name", base_url: "http://facebook.com", image_file_name: "icon4.png"}
            no_www_secure_attrs = {name: "platform5 name", base_url: "https://facebook.com", image_file_name: "icon5.png"}
            www_only_attrs = {name: "platform6 name", base_url: "www.facebook.com", image_file_name: "icon6.png"}
            domain_only_attrs = {name: "platform7 name", base_url: "facebook.com", image_file_name: "icon7.png"}
            resources_attrs = {name: "platform8 name", base_url: "https://www.linkedin.com/in", image_file_name: "icon8.png"}
            resources_trailing_slash_attrs = {name: "platform9 name", base_url: "https://www.reddit.com/user/", image_file_name: "icon9.png"}

            full = SocialPlatform.create(full_attrs)
            full_secure = SocialPlatform.create(full_secure_attrs)
            trailing_slash = SocialPlatform.create(trailing_slash_attrs)
            no_www = SocialPlatform.create(no_www_attrs)
            no_www_secure = SocialPlatform.create(no_www_secure_attrs)
            www_only = SocialPlatform.create(www_only_attrs)
            domain_only = SocialPlatform.create(domain_only_attrs)
            resources = SocialPlatform.create(resources_attrs)
            resources_trailing_slash = SocialPlatform.create(resources_trailing_slash_attrs)

            expect(full.format_base_url).to eq("www.facebook.com/")
            expect(full_secure.format_base_url).to eq("www.facebook.com/")
            expect(trailing_slash.format_base_url).to eq("www.facebook.com/")
            expect(no_www.format_base_url).to eq("www.facebook.com/")
            expect(no_www_secure.format_base_url).to eq("www.facebook.com/")
            expect(www_only.format_base_url).to eq("www.facebook.com/")
            expect(domain_only.format_base_url).to eq("www.facebook.com/")
            expect(resources.format_base_url).to eq("www.linkedin.com/in/")
            expect(resources_trailing_slash.format_base_url).to eq("www.reddit.com/user/")
        end

        # tests image_file_link method
        it "can create correct file path for image" do
            valid_attrs = {name: "platform", base_url: "https://www.example.com", image_file_name: "icon.png"}
            platform = SocialPlatform.create(valid_attrs)
            expect(platform.image_file_link).to eq("/images/icon.png")
        end

        # tests #slug method
        it "has a properly created slug" do
            one_word_attrs = {name: "name", base_url: "https://www.example1.com", image_file_name: "icon1.png"}
            one_word_cap_attrs = {name: "Platform", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
            multi_word_attrs = {name: "cool name for platform", base_url: "https://www.example3.com", image_file_name: "icon3.png"}
            multi_word_cap_attrs = {name: "cOOl PlatForm Name", base_url: "https://www.example4.com", image_file_name: "icon4.png"}
            crazy_one_word_attrs = {name: "n@mE!46", base_url: "https://www.example5.com", image_file_name: "icon5.png"}
            crazy_multi_word_attrs = {name: "cR@z4 p!atF0rm", base_url: "https://www.example6.com", image_file_name: "icon6.png"}

            one_word = SocialPlatform.create(one_word_attrs)
            one_word_cap = SocialPlatform.create(one_word_cap_attrs)
            multi_word = SocialPlatform.create(multi_word_attrs)
            multi_word_cap = SocialPlatform.create(multi_word_cap_attrs)
            crazy_one_word = SocialPlatform.create(crazy_one_word_attrs)
            crazy_multi_word = SocialPlatform.create(crazy_multi_word_attrs)
            
            expect(one_word.slug).to eq("name")
            expect(one_word_cap.slug).to eq("platform")
            expect(multi_word.slug).to eq("cool-name-for-platform")
            expect(multi_word_cap.slug).to eq("cool-platform-name")
            expect(crazy_one_word.slug).to eq("nme46")
            expect(crazy_multi_word.slug).to eq("crz4-patf0rm")
        end

        # tests .find_by_slug method
        it "can be found by its slug" do
            valid_attrs = {name: "cool name for platform", base_url: "https://www.example.com", image_file_name: "icon.png"}
            platform = SocialPlatform.create(valid_attrs)

            search_result = SocialPlatform.find_by_slug("cool-name-for-platform")
            expect(search_result).to eq(platform)
        end
    end
end