class CopySection < ActiveRecord::Base

    # attrs/table setup: id, name, css_class, page_location, headline, body_copy, link, timestamps
    # no associations needed at this time

    # name validation:
        # must exist, error message: "You must provide a name."
        # must be unique (case insensitive), error message: "That name is already use. Please provide another."

    # page_location validation:        
        # must be an integer, error message: "Page location must be a whole number."
        # must be an unique, error message: "You already have copy in that location. Please choose another."
        

    # helpers ################
    # need formatted_date
        # takes a timestamp (datetime) and converts to date only in mm/dd/yyyy (as a string)

    # need absolute_link?
        # checks if link is absolute or not (starts with "http://" of "https://" [maybe just "http" to cover both])
        # this is necessary so view can create link correctly
    
    # need slug
        # this will also be used for the css id
    
    # need find_by_slug()  ?????
        # not sure this is necessary - hold and see if everything works without it

    # view notes ################
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

    # link: if to external site, must have http:// in url, or won't link correctly
        # add instructions to make this clear
        # make value for href attribute use http:// if link is absolute


end