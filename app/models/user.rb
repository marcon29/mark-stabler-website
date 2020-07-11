class User < ActiveRecord::Base
	# attrs/table setup: first_name, last_name, email, username, password_digest, timestamps
	# no associations
	has_secure_password    

    validates :first_name, presence: { message: "You must provide your first name." }
    validates :last_name, presence: { message: "You must provide your last name." }
    validates :username, 
        presence: { message: "You must choose a username." },
        uniqueness: { case_sensitive: false, message: "That username is not available. Please use another." }, 
        format: { with: /\A\w+\z/, message: "Your username can only contain letters and numbers without spaces." }
    validates :email, 
        presence: { message: "You must provide your last email." }, 
        uniqueness: { case_sensitive: false, message: "That email is already used. Please use another." }, 
        format: { with: /\A\S+@\w+\.[a-zA-Z]{2,3}\z/, message: "Your email doesn't look valid. Please use another." }

	# helpers ################
	# need method_name
		# description of what method does

	def full_name
		"#{self.first_name.capitalize} #{self.last_name.capitalize}"
	end

	def self.find_by_slug(url_slug)
		self.all.find { |obj| obj.slug == url_slug }
	end

	def slug
		self.username.gsub(" ", "-").scan(/[[^\s\W]-]/).join.downcase
	end

	# view notes ################
		# add any notes based on validations and helpers so the proper data will appear in the view
end