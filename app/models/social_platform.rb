class SocialPlatform < ActiveRecord::Base
    # attrs/table setup: name, base_url, image_file


    # associations:
    has_many :social_profiles #destroy any social_profiles if a social_platform is deleted

    
    # attr validation:
        # all must both exist and be unique
        # image file must have .jpeg, .jpg, .png, .svg, .gif extension

        # name
        	# must exist, error message: "You must provide a name."
		    # must be unique (case insensitive), error message: "That platform already exists. Please provide another."

        # base_url
            # must exist, error message: "You must provide the base URL."
            # must be unique (case insensitive), error message: "That URL is already used for another platform. Please provide another."
                # run format_base_url before saving
            
        # image_file
            # must exist, error message: "You must provide the image file name."
		    # must be unique (case insensitive), error message: "That image file already exists. Please provide another."
		    # must have format, file extension must be one of: .jpeg .jpg .png .svg .gif, error message: "Only .jpeg, .jpg, .png, .svg, or .gif files are allowed."



        # social full url examples: final trailing slash, caps and www. don't matter
            # https://www.facebook.com/mark.stabler.984
            # https://www.facebook.com/StablerWriter/
            # https://twitter.com/stablerwriter/
            # https://www.instagram.com/stablerwriter/
            # https://www.linkedin.com/in/stablerwriter/
            # https://www.reddit.com/user/stablerwriter
            # https://github.com/marcon29



	# helpers ################
		# format_base_url
            # takes user url entry, removes http and https, ensures www. is there, ensures trailing slash
        
        # image_file link 
            # creates correct file path for image

        # slug
            # standard

        # self.find_by_slug
            # standard
            


	# view notes ################
        # the image file needs to be loaded in the correct place
            # add instructions on where it needs to go
            #


end