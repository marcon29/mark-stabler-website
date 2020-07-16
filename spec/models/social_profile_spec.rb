describe "SocialProfile" do
    # object creation and validation tests #######################################

    describe "can create and save valid instances " do
        it "can instantiate with a name, handle, and platform" do
            valid_platform_attrs = {name: "platform name", base_url: "https://www.example.com", image_file_name: "icon.png"}
            platform = SocialPlatform.create(valid_platform_attrs)

            valid_attrs = {name: "profile name", handle: "@profhandle"}
            profile = SocialProfile.new(valid_attrs)
            profile.social_platform = platform
            
            expect(profile.save).to be true
            expect(profile).to be_an_instance_of(SocialProfile)
            expect(profile.name).to eq("profile name")
            expect(profile.handle).to eq("profhandle")
            expect(profile.social_platform_id).to eq(platform.id)
        end
    end

    describe "has a required, unique name (case insensitive) and provides correct error message when invalid" do
        it "won't instantiate without a name" do
            valid_platform_attrs = {name: "platform name", base_url: "https://www.example.com", image_file_name: "icon.png"}
            platform = SocialPlatform.create(valid_platform_attrs)

            test_attrs = {name: "", handle: "@profhandle"}            
            no_name = SocialProfile.new(test_attrs)
            no_name.social_platform = platform
            
            expect(no_name.save).to be false
            expect(no_name.errors.messages[:name]).to include("You must provide a name.")
        end
        
        it "won't instantiate when name is same as other instance (case insensitive)" do
            valid_platform_attrs = {name: "platform name", base_url: "https://www.example.com", image_file_name: "icon.png"}
            platform = SocialPlatform.create(valid_platform_attrs)

            valid_attrs = {name: "profile name", handle: "@profhandle1"}
            test_attrs = {name: "profile name", handle: "@profhandle2"}
            test_attrs_cap = {name: "Profile Name", handle: "@profhandle3"}
            
            valid_instance = SocialProfile.new(valid_attrs)
            valid_instance.social_platform = platform
            valid_instance.save
            same_name = SocialProfile.new(test_attrs)
            same_name.social_platform = platform
            same_name_cap = SocialProfile.new(test_attrs_cap)
            same_name_cap.social_platform = platform

            expect(same_name.save).to be false
            expect(same_name.errors.messages[:name]).to include("That profile already exists. Please provide another.")
            expect(same_name_cap.save).to be false
            expect(same_name_cap.errors.messages[:name]).to include("That profile already exists. Please provide another.")
        end
    end

    describe "has a required, properly formatted handle that is unique to the associated platform (case insensitive) and provides correct error message when invalid" do
        it "won't instantiate without a handle" do
            valid_platform_attrs = {name: "platform name", base_url: "https://www.example.com", image_file_name: "icon.png"}
            platform = SocialPlatform.create(valid_platform_attrs)

            test_attrs = {name: "profile name", handle: ""}
            no_handle = SocialProfile.new(test_attrs)
            no_handle.social_platform = platform
            
            expect(no_handle.save).to be false
            expect(no_handle.errors.messages[:handle]).to include("You must provide a valid profile handle. Can only use letters, numbers, periods, hyphens, underscores. Spaces and @'s will be removed.")
        end
        
        it "won't instantiate when handle is same as other instance but only on same platform (case insensitive)" do
            valid_platform1_attrs = {name: "platform1 name", base_url: "https://www.example1.com", image_file_name: "icon1.png"}
            valid_platform2_attrs = {name: "platform2 name", base_url: "https://www.example2.com", image_file_name: "icon2.png"}
            platform1 = SocialPlatform.create(valid_platform1_attrs)
            platform2 = SocialPlatform.create(valid_platform2_attrs)

            valid_attrs = {name: "profile1 name", handle: "@profhandle"}
            test_attrs = {name: "profile2 name", handle: "@profhandle"}
            test_attrs_cap = {name: "profile3 name", handle: "@ProfHandle"}
            diff_platform_attrs = {name: "profile4 name", handle: "@profhandle"}
            
            valid_instance = SocialProfile.new(valid_attrs)
            valid_instance.social_platform = platform1
            valid_instance.save

            same_handle = SocialProfile.new(test_attrs)
            same_handle.social_platform = platform1
            same_handle_cap = SocialProfile.new(test_attrs_cap)
            same_handle_cap.social_platform = platform1
            diff_platform = SocialProfile.new(diff_platform_attrs)
            diff_platform.social_platform = platform2

            expect(same_handle.save).to be false
            expect(same_handle.errors.messages[:handle]).to include("That handle is already used for that platform. Please provide another.")
            expect(same_handle_cap.save).to be false
            expect(same_handle_cap.errors.messages[:handle]).to include("That handle is already used for that platform. Please provide another.")
            expect(diff_platform.save).to be true
        end

        it "won't instantiate when handle has punctuation (except dots, hyphen, underscores) or special characters (except @)" do
            valid_platform_attrs = {name: "platform name", base_url: "https://www.example.com", image_file_name: "icon.png"}
            platform = SocialPlatform.create(valid_platform_attrs)

            test_char_attrs = {name: "profile1 name", handle: "prof$ha&dl#1"}
            test_punc_attrs = {name: "profile2 name", handle: "prof,han?d!e2"}

            test_char = SocialProfile.new(test_char_attrs)
            test_char.social_platform = platform
            test_punc = SocialProfile.new(test_punc_attrs)
            test_punc.social_platform = platform

            expect(test_char.save).to be false
            expect(test_char.errors.messages[:handle]).to include("You must provide a valid profile handle. Can only use letters, numbers, periods, hyphens, underscores. Spaces and @'s will be removed.")
            expect(test_punc.save).to be false
            expect(test_punc.errors.messages[:handle]).to include("You must provide a valid profile handle. Can only use letters, numbers, periods, hyphens, underscores. Spaces and @'s will be removed.")
        end

        it "will instantiate with a variety of possible handle user entries" do
            # will work with @ or no @, spaces, dots, hyphens
            # running the format handle method during validations makes this work

            valid_platform_attrs = {name: "platform name", base_url: "https://www.example.com", image_file_name: "icon.png"}
            platform = SocialPlatform.create(valid_platform_attrs)

            has_at_attrs = {name: "profile1 name", handle: "@profhandle1"}
            no_at_attrs = {name: "profile2 name", handle: "profhandle2"}
            has_spaces_attrs = {name: "profile3 name", handle: "prof handle3"}
            has_dots_attrs = {name: "profile4 name", handle: "prof.handle.4"}
            has_hyphens_attrs = {name: "profile5 name", handle: "prof-handle-5"}
            has_underscore_attrs = {name: "profile6 name", handle: "prof_handle_6"}

            has_at = SocialProfile.new(has_at_attrs)
            has_at.social_platform = platform
            no_at = SocialProfile.new(no_at_attrs)
            no_at.social_platform = platform
            has_spaces = SocialProfile.new(has_spaces_attrs)
            has_spaces.social_platform = platform
            has_dots = SocialProfile.new(has_dots_attrs)
            has_dots.social_platform = platform
            has_hyphens = SocialProfile.new(has_hyphens_attrs)
            has_hyphens.social_platform = platform
            has_underscore = SocialProfile.new(has_underscore_attrs)
            has_underscore.social_platform = platform

            expect(has_at.save).to be true
            expect(no_at.save).to be true
            expect(has_spaces.save).to be true
            expect(has_dots.save).to be true
            expect(has_hyphens.save).to be true
            expect(has_underscore.save).to be true
        end
    end

    describe "can have a unique display_order that is an integer and provides correct error message when invalid" do
        it "won't instantiate when display_order is same as other instance" do
            valid_platform_attrs = {name: "platform name", base_url: "https://www.example.com", image_file_name: "icon.png"}
            platform = SocialPlatform.create(valid_platform_attrs)

            valid_instance = SocialProfile.create(name: "profile1 name", handle: "@profhandle1", display_order: 1)
            valid_instance.social_platform = platform
            valid_instance.save
            same_position = SocialProfile.create(name: "dupe location", handle: "@profhandle2", display_order: 1)
            same_position.social_platform = platform
            
            expect(same_position.save).to be false            
            expect(same_position.errors.messages[:display_order]).to include("You already have a profile in that position. Please choose another.")
        end

        it "won't instantiate when display_order is not an integer" do
            valid_platform_attrs = {name: "platform name", base_url: "https://www.example.com", image_file_name: "icon.png"}
            platform = SocialPlatform.create(valid_platform_attrs)

            valid_instance = SocialProfile.create(name: "profile1 name", handle: "@profhandle1", display_order: 1)
            valid_instance.social_platform = platform
            valid_instance.save
            not_num = SocialProfile.create(name: "not number", handle: "@profhandle2", display_order: "five")
            not_num.social_platform = platform
            
            expect(not_num.save).to be false            
            expect(not_num.errors.messages[:display_order]).to include("Display order must be a whole number.")
        end
    end

    # model association tests ####################################################
    describe "works with assoicated models correctly" do
        it "belongs to social_platform" do
            valid_platform_attrs = {name: "platform name", base_url: "https://www.example.com", image_file_name: "icon.png"}
            platform = SocialPlatform.create(valid_platform_attrs)

            profile1_attrs = {name: "profile one", handle: "@profileone"}
            profile2_attrs = {name: "profile two", handle: "@profiletwo"}
            
            profile1 = SocialProfile.new(profile1_attrs)            
            profile1.social_platform = platform
            profile1.save
            profile2 = SocialProfile.new(profile2_attrs)
            profile2.social_platform_id = platform.id
            profile2.save

            expect(profile1.save).to be true
            expect(profile1.social_platform.name).to eq("platform name")
            expect(profile1.social_platform.base_url).to eq("www.example.com/")
            expect(profile1.social_platform.image_file_name).to eq("icon.png")
            expect(profile2.save).to be true
            expect(profile2.social_platform.name).to eq("platform name")
            expect(profile2.social_platform.base_url).to eq("www.example.com/")
            expect(profile2.social_platform.image_file_name).to eq("icon.png")
        end

        it "won't instantiate unless associated to a platform" do
            invalid_platform_attrs = {name: "", base_url: "https://www.example.com", image_file_name: "icon.png"}
            no_platform_attrs = {name: "profile1 name", handle: "@profhandle1"}
            bad_assoc_attrs = {name: "profile2 name", handle: "@profhandle2"}

            invalid_platform = SocialPlatform.create(invalid_platform_attrs)
            no_platform = SocialProfile.new(no_platform_attrs)
            bad_assoc = SocialProfile.new(bad_assoc_attrs)
            bad_assoc.social_platform = invalid_platform

            expect(no_platform.save).to be false
            expect(no_platform.errors.messages[:social_platform]).to include("Your profile must belong to a platform.")
            expect(bad_assoc.save).to be false
            expect(bad_assoc.errors.messages[:social_platform]).to include("Your profile must belong to a platform.")
        end
    end


    # helper method tests ########################################################
    describe "all helper methods work correctly" do
        
        # tests format_handle method
        it "can take a user's handle entry and format it to set up correct link text for view" do
            valid_platform_attrs = {name: "platform name", base_url: "https://www.example.com", image_file_name: "icon.png"}
            platform = SocialPlatform.create(valid_platform_attrs)

            has_at_attrs = {name: "profile1 name", handle: "@ProfHandle1"}
            has_spaces_attrs = {name: "profile2 name", handle: "Prof Handle2"}
            has_at_spaces_attrs = {name: "profile3 name", handle: "@Prof Handle3"}
            has_dots_attrs = {name: "profile4 name", handle: "@Prof.Handle4"}
            has_hyphens_attrs = {name: "profile5 name", handle: "@Prof-Handle5"}

            has_at = SocialProfile.new(has_at_attrs)
            has_at.social_platform = platform
            has_at.save
            has_spaces = SocialProfile.new(has_spaces_attrs)
            has_spaces.social_platform = platform
            has_spaces.save            
            has_at_spaces = SocialProfile.new(has_at_spaces_attrs)
            has_at_spaces.social_platform = platform
            has_at_spaces.save            
            has_dots = SocialProfile.new(has_dots_attrs)
            has_dots.social_platform = platform
            has_dots.save            
            has_hyphens = SocialProfile.new(has_hyphens_attrs)
            has_hyphens.social_platform = platform
            has_hyphens.save

            expect(has_at.format_handle).to eq("profhandle1")
            expect(has_spaces.format_handle).to eq("profhandle2")
            expect(has_at_spaces.format_handle).to eq("profhandle3")
            expect(has_dots.format_handle).to eq("prof.handle4")
            expect(has_hyphens.format_handle).to eq("prof-handle5")
        end

        # tests link method
        it "can create correct link URL for profile" do
            valid_platform_attrs = {name: "platform name", base_url: "https://www.example.com", image_file_name: "icon.png"}
            platform = SocialPlatform.create(valid_platform_attrs)
            
            valid_attrs = {name: "profile", handle: "@profhandle"}
            profile = SocialProfile.new(valid_attrs)
            profile.social_platform = platform
            profile.save

            expect(profile.link).to eq("www.example.com/profhandle")
        end

        # tests #slug method
        it "has a properly created slug" do
            valid_platform_attrs = {name: "platform name", base_url: "https://www.example.com", image_file_name: "icon.png"}
            platform = SocialPlatform.create(valid_platform_attrs)
            
            one_word_attrs = {name: "name", handle: "@profhandle1"}
            one_word_cap_attrs = {name: "Profile", handle: "@profhandle2"}
            multi_word_attrs = {name: "cool name for profile", handle: "@profhandle3"}
            multi_word_cap_attrs = {name: "cOOl ProFile Name", handle: "@profhandle4"}
            crazy_one_word_attrs = {name: "n@mE!46", handle: "@profhandle5"}
            crazy_multi_word_attrs = {name: "cR@z4 p40f!Le", handle: "@profhandle6"}

            one_word = SocialProfile.new(one_word_attrs)
            one_word.social_platform = platform
            one_word.save
            one_word_cap = SocialProfile.new(one_word_cap_attrs)
            one_word_cap.social_platform = platform
            one_word_cap.save
            multi_word = SocialProfile.new(multi_word_attrs)
            multi_word.social_platform = platform
            multi_word.save
            multi_word_cap = SocialProfile.new(multi_word_cap_attrs)
            multi_word_cap.social_platform = platform
            multi_word_cap.save
            crazy_one_word = SocialProfile.new(crazy_one_word_attrs)
            crazy_one_word.social_platform = platform
            crazy_one_word.save
            crazy_multi_word = SocialProfile.new(crazy_multi_word_attrs)
            crazy_multi_word.social_platform = platform
            crazy_multi_word.save

            expect(one_word.slug).to eq("name")
            expect(one_word_cap.slug).to eq("profile")
            expect(multi_word.slug).to eq("cool-name-for-profile")
            expect(multi_word_cap.slug).to eq("cool-profile-name")
            expect(crazy_one_word.slug).to eq("nme46")
            expect(crazy_multi_word.slug).to eq("crz4-p40fle")
        end

        # tests .find_by_slug method
        it "can be found by its slug" do
            valid_platform_attrs = {name: "platform name", base_url: "https://www.example.com", image_file_name: "icon.png"}
            platform = SocialPlatform.create(valid_platform_attrs)

            valid_attrs = {name: "cool name for profile", handle: "@profhandle"}
            profile = SocialProfile.new(valid_attrs)
            profile.social_platform = platform
            profile.save

            search_result = SocialProfile.find_by_slug("cool-name-for-profile")
            expect(search_result).to eq(profile)
        end
    end
end