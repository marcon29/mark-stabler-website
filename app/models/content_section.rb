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

    # not sure this is necessary - hold and see if everything works without it
    # def self.find_by_slug(url_slug)
    #     self.all.find { |obj| obj.slug == url_slug }
    # end   
    
        

    # view notes ####################################
    # page location will also determine content order    
        # provide these instructions on the new and edit pages
        # provide a single edit view with all copy sections
            # blank = will not appear (use for WIP copy and to turn things off without deleting them)
            # 0 = intro section
            # 1 = all services center
            # 2 = all services top left
            # 3 = all services top right
            # 4 = all services bottom
            # 5+ = about section (in order)

    # link: if to external site, must have "http" or "www" in url or won't link correctly
        # add instructions to make this clear
        # make value for href attribute use http:// if link is absolute

    # formatted date: check on "if date" if not an issue in view, remove from method in model


end