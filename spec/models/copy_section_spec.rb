require 'spec_helper'

describe "CopySection" do
    # before(:each) - clear copy_sections table in test DB
        # don't think I need this - set up in spec_helper already
        # test without this and see if works
    # end
        
    # object creation and validation tests #######################################
    it "can have a css_class, page_location, headline, body_copy, link" do
        # create a valid instance with all attrs
            # expect instance.css_class to equal "the given class"
            # expect instance.page_location to equal "the given location"
            # expect instance.headline to equal "the given headline"
            # expect instance.body_copy to equal "the given copy"
            # expect instance.link to equal "the given link"
        
        # create a valid instance with only name
            # expect instance.css_class.empty? to be true
            # expect instance.page_location.empty? to be true
            # expect instance.headline.empty? to be true
            # expect instance.body_copy.empty? to be true
            # expect instance.link to equal.empty? to be true
    end
    
    it "has a required, unique name (case insensitive) and provides correct error message when invalid" do
        # create and persist a valid seed instance
        # create an instance without a name
            # expect instance.save to be false
            # expect instance.errors.messages to be "You must provide a name."
        # create an instance with same name as seed (same case)
            # expect instance.save to be false
            # expect instance.errors.messages to be "That name is already used. Please provide another."
        # create an instance with same name as seed (different case)
            # expect instance.save to be false
            # expect instance.errors.messages to be "That name is already use. Please provide another."
        # create an instance with different name as seed
            # expect instance.name to equal "the given name"
    end

    it "can have a unique page_location that is an integer and provides correct error message when invalid" do
        # create and persist a valid seed instance
        # create an instance with name (diff from seed) and location that's not a number
            # expect instance.save to be false
            # expect instance.errors.messages to be "Page location must be a whole number."
        # create an instance with name (diff from seed) and same location as seed
            # expect instance.save to be false
            # expect instance.errors.messages to be "You already have copy in that location. Please choose another."
        # create an instance with name (diff from seed) and different location as seed
            # expect instance.page_location to equal "the given location"
    end
    
    # helper method tests ########################################################
    it "can tell if the link is absolute or relative" do
        # create instance1 with name and absolute link
            # expect instance.absolute_link? to be true
        # create instance2 with name and relative link
            # expect instance.absolute_link? to be false
    end
    
    it "has a properly created slug" do
        # create an instance with all attrs (one-word name)
            # expect instance.slug to equal "the given name in correct slug format"
        # create an instance with all attrs (one-word name, capitalized)
            # expect instance.slug to equal "the given name in correct slug format"
        # create an instance with all attrs (one-word name, w/ punctuation and special characters)
            # expect instance.slug to equal "the given name in correct slug format"
        # create an instance with all attrs (multi-word name, mixed case, w/ punctuation and special characters)
            # expect instance.slug to equal "the given name in correct slug format"
    end
    
    # not sure this is necessary - create but comment out and see if everything works without it, use in other classes if not needed here
    it "can be found by its slug" do
        # create an instance with all attrs (multi-word name, mixed case, w/ punctuation and special characters)
            # expect instance.find_by_slug("given name in slug format") to equal the instance
    end
    
    it "can return only the properly formatted date of when the object was created and updated" do
        # create and persist a valid instance (only need name)
            # expect instance.created_at.formatted_date to equal "the created date in correct date format ("mm/dd/yyyy")"
            # expect instance.created_at.updated_at to equal "the created date in correct date format ("mm/dd/yyyy")"
    end
end


