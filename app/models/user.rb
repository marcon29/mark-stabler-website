class User < ActiveRecord::Base   
    has_secure_password    

    validates :first_name, presence: { message: "You must provide your first name." }
    validates :last_name, presence: { message: "You must provide your last name." }
    validates :email, 
        presence: { message: "You must provide your email." }, 
        uniqueness: { case_sensitive: false, message: "That email is already used. Please use another." }, 
        format: { with: /\A\S+@\w+\.[a-zA-Z]{2,3}\z/, message: "Your email doesn't look valid. Please use another." }
    validates :username, 
        presence: { message: "You must choose a username." }, 
        uniqueness: { case_sensitive: false, message: "That username is not available. Please use another." }, 
        format: { with: /\A\w+\z/, message: "Your username can only contain letters and numbers without spaces." }


	# helpers ################
	def full_name
		"#{self.first_name.capitalize} #{self.last_name.capitalize}"
    end   
end