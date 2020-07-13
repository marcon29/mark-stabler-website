class SocialProfile < ActiveRecord::Base
    # attrs/table setup: name, handle, social_platform_id


    # associations:
    # belongs_to :social_platform

    
    # attr validation:
        # name and handle, they must both exist and be unique

        # name 
            # must exist, error message: "You must provide a name."
		    # must be unique (case insensitive), error message: "That profile already exists. Please provide another."
		
        # handle
		    # must exist, error message: "You must provide your profile handle."
            # must be unique (case insensitive), error message: "That handle is already used for that platform. Please provide another."
                # uniqness is limited to the same platform
            # format: { with: /\A\w+\z/, message: "That handle doesn't look valid. Please provide another." }
            # run format_handle before saving
        
         # social_platform_id
		    # must exist, error message: "Your profile must belong to a platform."
            

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
    # removes @ and spaces if included
    # def format_handle
    #     # self.handle.gsub(/[@ ]/, "").downcase
    # end

    # # creates link url from SocialPlatform.base_url + SocialProfile.handle
    # def link
    #     # "#{self.platform.base_url}/#{self.handle}"
    # end

    # def slug
    #     # self.name.gsub(" ", "-").scan(/[[^\s\W]-]/).join.downcase
    # end
    
    # def self.find_by_slug(url_slug)
    #     # self.all.find { |obj| obj.slug == url_slug }
    # end
            

            
	# view notes ################
		# add any notes based on validations and helpers so the proper data will appear in the view





end