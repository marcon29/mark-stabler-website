class ContentSection < ActiveRecord::Base
    validates :name, 
        presence: { message: "You must provide a name." }, 
        uniqueness: { case_sensitive: false, message: "That name is already used. Please provide another."}    
    validates :page_location,
        uniqueness: { message: "You already have content in that location. Please choose another."},
        numericality: { only_integer: true, message: "Page location must be a whole number."},
        allow_blank: true


    def formatted_link_url
        if absolute_link?
            self.link_url.gsub(/(https:\/\/|http:\/\/)/, "")
        else
            self.link_url
        end
    end

    # def format_url
    #     string = self.url.gsub(/(https:\/\/|http:\/\/)?(www.)?/, "").strip.downcase
       
    #     string.ends_with?('/') ? string = string.chomp("/") : string
    #     self.url = string if !string.empty?
    # end

    # allows view to create <a> href attribute correctly
    def absolute_link?
        !!self.link_url.match(/http|www\./)
    end
    
    # creates html id attribute value for css targeting
    def css_id
        "con-sec-#{self.page_location}" if self.page_location
    end

    def slug
        self.name.gsub(" ", "-").scan(/[[^\s\W]-]/).join.downcase
    end
    
    def self.find_by_slug(url_slug)
        self.all.find { |obj| obj.slug == url_slug }
    end
end