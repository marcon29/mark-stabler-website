class SocialPlatform < ActiveRecord::Base
    has_many :social_profiles, :dependent => :destroy

    validates :name, 
        presence: { message: "You must provide a name." }, 
        uniqueness: { case_sensitive: false, message: "That platform already exists. Please provide another." }    
    validates :base_url, 
        presence: { message: "You must provide the base URL." }, 
        uniqueness: { case_sensitive: false, message: "That URL is already used for another platform. Please provide another." }, 
        format: { with: /\A\Awww\.\w+\.[a-zA-Z]{2,3}\/((\w+\/)+|\z)/, message: "That URL doesn't look valid. Please provide another." }
    validates :image_file_name, 
        presence: { message: "You must provide the image file name." }, 
        uniqueness: { case_sensitive: false, message: "That image file already exists. Please provide another." }, 
        format: { with: /\A(\w+.jpeg|\w+.jpg|\w+.png|\w+.svg)\z/, message: "Only .jpeg, .jpg, .png, or .svg files are allowed." }
    before_validation :format_base_url


    # helpers ################
    # takes user's url entry, removes http and https, ensures www. is there, ensures trailing slash
    def format_base_url
        string = self.base_url.gsub(/(https:\/\/|http:\/\/)?(www.)?/, "").strip.downcase

        if !string.empty?
            if string.ends_with?('/')
                string = "www.#{string}"
            else
                string = ("www.#{string}/")
            end
            
            self.base_url = string
        end
    end    
    
    # creates correct file path for image (requires "images" directory in "public" directory)
    def image_file_link
        "/images/#{self.image_file_name}"
    end

    def slug
        self.name.gsub(" ", "-").scan(/[[^\s\W]-]/).join.downcase
    end
    
    def self.find_by_slug(url_slug)
        self.all.find { |obj| obj.slug == url_slug }
    end
         


	# view notes ################
        # the image file needs to be loaded in the correct place
            # add instructions on where it needs to go
            #


end