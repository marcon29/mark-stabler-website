class SocialProfile < ActiveRecord::Base
    belongs_to :social_platform

    validates :name, 
        presence: { message: "You must provide a name." }, 
        uniqueness: { case_sensitive: false, message: "That profile already exists. Please provide another." }
    validates :handle, 
        presence: { message: "You must provide a valid profile handle. Can only use letters, numbers, periods, hyphens, underscores. Spaces and @'s will be removed." }, 
        uniqueness: { case_sensitive: false, scope: :social_platform, message: "That handle is already used for that platform. Please provide another." }

    validates :display_order,
        uniqueness: { message: "You already have a profile in that position. Please choose another." },
        numericality: { only_integer: true, message: "Display order must be a whole number." },
        allow_blank: true

    validates :social_platform, presence: { message: "Your profile must belong to a platform." }
    validates_associated :social_platform, message: "Your profile must belong to a platform."
    before_validation :format_handle

    
	# helpers ################
    def format_handle
        string = self.handle.gsub(/[@ ]/, "").downcase
        
        if string.scan(/[^\w\-_\.]/).empty?
            self.handle = string.gsub(/[@ ]/, "").downcase
        else
            self.handle = ""
        end
    end

    # creates link url from SocialPlatform.base_url + SocialProfile.handle
    def link
        "#{self.social_platform.base_url}#{self.handle}"        
    end

    def slug
        self.name.gsub(" ", "-").scan(/[[^\s\W]-]/).join.downcase
    end
    
    def self.find_by_slug(url_slug)
        self.all.find { |obj| obj.slug == url_slug }
    end
            

            
	# view notes ################
		# add any notes based on validations and helpers so the proper data will appear in the view





end