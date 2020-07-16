class ContentSection < ActiveRecord::Base
    validates :name, 
        presence: { message: "You must provide a name." }, 
        uniqueness: { case_sensitive: false, message: "That name is already used. Please provide another."}    
    validates :page_location,
        uniqueness: { message: "You already have content in that location. Please choose another."},
        numericality: { only_integer: true, message: "Page location must be a whole number."},
        allow_blank: true

    # allows view to create <a> href attribute correctly
    def absolute_link?
        !!self.link_url.match(/http|www\./)
    end
    
    # this will also be used for the css id
    def slug
        self.name.gsub(" ", "-").scan(/[[^\s\W]-]/).join.downcase
    end
    
    def self.find_by_slug(url_slug)
        self.all.find { |obj| obj.slug == url_slug }
    end
end