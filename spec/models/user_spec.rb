describe "User" do
    # object creation and validation tests #######################################

    it "can instantiate with a first_name, last_name, email, username, and password" do        
        valid_attrs = {first_name: "Joe", last_name: "Blow", email: "joe_blow@example.com", username: "testuser1", password: "test"}
        user = User.create(valid_attrs)
        
        expect(user.valid?).to be true
        expect(user).to be_an_instance_of(User)

        expect(user.first_name).to eq("Joe")
        expect(user.last_name).to eq("Blow")
        expect(user.email).to eq("joe_blow@example.com")
        expect(user.username).to eq("testuser1")
        expect(user.authenticate("test")).to be_truthy
    end

    describe "has a required first and last name and provides correct error message when invalid" do
        it "won't instantiate without a first name" do
            test_attrs = {first_name: "", last_name: "Blow", email: "joe_blow@example.com", username: "testuser1", password: "test"}
            no_name = User.create(test_attrs)

            expect(no_name.save).to be false
            expect(no_name.errors.messages[:first_name]).to include("You must provide your first name.")
        end

        it "won't instantiate without a last name" do
            test_attrs = {first_name: "Joe", last_name: "", email: "joe_blow@example.com", username: "testuser1", password: "test"}
            no_name = User.create(test_attrs)
                        
            expect(no_name.save).to be false
            expect(no_name.errors.messages[:last_name]).to include("You must provide your last name.")
        end
    end
    
    describe "has a required, unique email (case insensitive) that matches standard email text patterns and provides correct error message when invalid" do
        it "won't instantiate without an email" do
            test_attrs = {first_name: "Joe", last_name: "Blow", email: "", username: "testuser1", password: "test"}
            no_email = User.create(test_attrs)
            
            expect(no_email.save).to be false
            expect(no_email.errors.messages[:email]).to include("You must provide your email.")
        end
        
        it "won't instantiate when email is same as other instance (case insensitive)" do
            valid_attrs = {first_name: "Joe", last_name: "Blow", email: "joe_blow@example.com", username: "testuser1", password: "test"}
            test_attrs = {first_name: "Jane", last_name: "Doe", email: "joe_blow@example.com", username: "testuser2", password: "test"}
            test_attrs_cap = {first_name: "Jane", last_name: "Doe", email: "Joe_Blow@example.com", username: "testuser3", password: "test"}
            
            valid_instance = User.create(valid_attrs)
            same_email = User.create(test_attrs)
            same_email_cap = User.create(test_attrs_cap)

            expect(same_email.save).to be false
            expect(same_email.errors.messages[:email]).to include("That email is already used. Please use another.")
            expect(same_email_cap.save).to be false
            expect(same_email_cap.errors.messages[:email]).to include("That email is already used. Please use another.")
        end

        it "won't instantiate when email doesn't follow standard email text pattern" do
            no_at_attrs = {first_name: "Joe", last_name: "Blow", email: "joe_blowexample.com", username: "testuser1", password: "test"}
            no_dot_attrs = {first_name: "Joe", last_name: "Blow", email: "joe_blow@examplecom", username: "testuser2", password: "test"}
            no_tld_attrs = {first_name: "Joe", last_name: "Blow", email: "joe_blow@example.", username: "testuser3", password: "test"}
            short_tld_attrs = {first_name: "Joe", last_name: "Blow", email: "joe_blow@example.c", username: "testuser4", password: "test"}
            long_tld_attrs = {first_name: "Joe", last_name: "Blow", email: "joe_blow@example.comm", username: "testuser5", password: "test"}
            bad_tld_attrs = {first_name: "Joe", last_name: "Blow", email: "joe_blow@example.c2m", username: "testuser6", password: "test"}
            no_name_attrs = {first_name: "Joe", last_name: "Blow", email: "@example.com", username: "testuser7", password: "test"}
            no_domain_attrs = {first_name: "Joe", last_name: "Blow", email: "joe_blow@.com", username: "testuser8", password: "test"}
            has_spaces_attrs = {first_name: "Joe", last_name: "Blow", email: "joe blow@example.com", username: "testuser9", password: "test"}

            no_at = User.create(no_at_attrs)
            no_dot = User.create(no_dot_attrs)
            no_tld = User.create(no_tld_attrs)
            short_tld = User.create(short_tld_attrs)
            long_tld = User.create(long_tld_attrs)
            bad_tld = User.create(bad_tld_attrs)
            no_name = User.create(no_name_attrs)
            no_domain = User.create(no_domain_attrs)
            has_spaces = User.create(has_spaces_attrs)

            expect(no_at.save).to be false
            expect(no_at.errors.messages[:email]).to include("Your email doesn't look valid. Please use another.")
            expect(no_dot.save).to be false
            expect(no_dot.errors.messages[:email]).to include("Your email doesn't look valid. Please use another.")
            expect(no_tld.save).to be false
            expect(no_tld.errors.messages[:email]).to include("Your email doesn't look valid. Please use another.")
            expect(short_tld.save).to be false
            expect(short_tld.errors.messages[:email]).to include("Your email doesn't look valid. Please use another.")
            expect(long_tld.save).to be false
            expect(long_tld.errors.messages[:email]).to include("Your email doesn't look valid. Please use another.")
            expect(bad_tld.save).to be false
            expect(bad_tld.errors.messages[:email]).to include("Your email doesn't look valid. Please use another.")
            expect(no_name.save).to be false
            expect(no_name.errors.messages[:email]).to include("Your email doesn't look valid. Please use another.")
            expect(no_domain.save).to be false
            expect(no_domain.errors.messages[:email]).to include("Your email doesn't look valid. Please use another.")
            expect(has_spaces.save).to be false
            expect(has_spaces.errors.messages[:email]).to include("Your email doesn't look valid. Please use another.")
        end
    end

    describe "has a required, unique username (case insensitive) and provides correct error message when invalid" do
        it "won't instantiate without a username" do
            test_attrs = {first_name: "Joe", last_name: "Blow", email: "joe_blow@example.com", username: "", password: "test"}
            no_username = User.create(test_attrs)
            
            expect(no_username.save).to be false
            expect(no_username.errors.messages[:username]).to include("You must choose a username.")
        end
        
        it "won't instantiate when username is same as other instance (case insensitive)" do
            valid_attrs = {first_name: "Joe", last_name: "Blow", email: "joe_blow@example.com", username: "testuser1", password: "test"}
            test_attrs = {first_name: "Jane", last_name: "Doe", email: "jane.doe@example.com", username: "testuser1", password: "test"}
            test_attrs_cap = {first_name: "Jane", last_name: "Doe", email: "jane@example.com", username: "TestUser1", password: "test"}

            valid_instance = User.create(valid_attrs)
            same_name = User.create(test_attrs)
            same_name_cap = User.create(test_attrs_cap)

            expect(same_name.save).to be false
            expect(same_name.errors.messages[:username]).to include("That username is not available. Please use another.")
            expect(same_name_cap.save).to be false
            expect(same_name_cap.errors.messages[:username]).to include("That username is not available. Please use another.")
        end

        it "won't instantiate when username contains spaces or special characters" do
            test_space_attrs = {first_name: "Joe", last_name: "Blow", email: "joe_blow@example.com", username: "test user3", password: "test"}
            test_char_attrs = {first_name: "Jane", last_name: "Doe", email: "jane.doe@example.com", username: "te$t%u$er5", password: "test"}
            test_punc_attrs = {first_name: "Jane", last_name: "Doe", email: "jane@example.com", username: "test.user5!", password: "test"}

            test_spaces = User.create(test_space_attrs)
            test_char = User.create(test_char_attrs)
            test_punc = User.create(test_punc_attrs)

            expect(test_spaces.save).to be false
            expect(test_spaces.errors.messages[:username]).to include("Your username can only contain letters and numbers without spaces.")
            expect(test_char.save).to be false
            expect(test_char.errors.messages[:username]).to include("Your username can only contain letters and numbers without spaces.")
            expect(test_punc.save).to be false
            expect(test_punc.errors.messages[:username]).to include("Your username can only contain letters and numbers without spaces.")
        end
    end

    describe "has a required password" do
        it "won't instantiate without a password" do
            test_attrs = {first_name: "Joe", last_name: "Blow", email: "joe_blow@example.com", username: "testuser1", password: ""}
            no_password = User.create(test_attrs)
            
            expect(no_password.save).to be false
            expect(no_password.errors.messages[:password]).to include("can't be blank")
        end
    end


    # helper method tests ########################################################
    describe "all helper methods work correctly" do
        # tests full_name method
        it "can create a properly formatted full name from user's first and last name" do
            test_attrs = {first_name: "Joe", last_name: "Blow", email: "joe_blow@example.com", username: "testuser1", password: "test"}
            test_attrs_cap = {first_name: "jane", last_name: "doe", email: "jane.doe@example.com", username: "testuser2", password: "test"}
            
            user = User.create(test_attrs)
            user_cap = User.create(test_attrs_cap)

            expect(user.full_name).to eq("Joe Blow")
            expect(user_cap.full_name).to eq("Jane Doe")
        end
    end
end