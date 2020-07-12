class SocialProfile < ActiveRecord::Base
    # attrs/table setup: name, handle, notes, social_platform_id


    # associations:
    belongs_to :social_platform

    
    # attr validation:
        # name and handle, they must both exist and be unique

        # name 
            # must exist, error message: "You must provide a name."
		    # must be unique (case insensitive), error message: "That name is already used. Please provide another."
		
        # handle
		    # must exist, error message: "You must provide your profile handle."
            # must be unique (case insensitive), error message: "That handle is already used for that platform. Please provide another."
                # uniqness is limited to the same platform
            # run format_handle before saving


            # social full url examples: final trailing slash, caps and www. don't matter
            # https://www.facebook.com/mark.stabler.984
            # https://www.facebook.com/StablerWriter/
            # https://twitter.com/stablerwriter/
            # https://www.instagram.com/stablerwriter/
            # https://www.linkedin.com/in/stablerwriter/
            # https://www.reddit.com/user/stablerwriter
            # https://github.com/marcon29


    ######### revisit association tests in platform class to make sure handle input is correct #################
		    


	# helpers ################
		# link
            # creates link url from SocialPlatform.base_url + SocialProfile.handle
        
        # format_handle 
            # removes @ if included

        # slug
            # standard slug, but should comprise of SocialPlatform.name and SocialProfile.name

        # self.find_by_slug
            # standard
            

            
	# view notes ################
		# add any notes based on validations and helpers so the proper data will appear in the view





end