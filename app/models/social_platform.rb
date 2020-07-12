class SocialPlatform < ActiveRecord::Base
    # attrs/table setup: name, base_url, image_file_name


    # associations:
    # has_many :social_profiles #destroy any social_profiles if a social_platform is deleted

    
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
    
    # takes user's url entry, removes http and https, ensures www. is there, ensures trailing slash
    def format_base_url
        # string = check.gsub(/(https:\/\/|http:\/\/)?(www.)?/, "").strip.downcase

        # if string.ends_with?('/')
        #     string = "www.#{string}"
        # else
        #     string = ("www.#{string}/")
        # end
        
        # self.base_url = string # if !string.empty?
    end    
    
    # creates correct file path for image (requires "images" directory in "public" directory)
    def image_file_link
        # "/images/#{self.image_file_name}"
    end

    def slug
        # self.name.gsub(" ", "-").scan(/[[^\s\W]-]/).join.downcase
    end
    
    def self.find_by_slug(url_slug)
        # self.all.find { |obj| obj.slug == url_slug }
    end
         


	# view notes ################
        # the image file needs to be loaded in the correct place
            # add instructions on where it needs to go
            #


end