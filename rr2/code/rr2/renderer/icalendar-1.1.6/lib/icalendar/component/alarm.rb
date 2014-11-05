#---
# Excerpted from "Rails Recipes",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rr2 for more book information.
#---
=begin
  Copyright (C) 2005 Jeff Rose

  This library is free software; you can redistribute it and/or modify it
  under the same terms as the ruby language itself, see the file COPYING for
  details.
=end
module Icalendar 
  # An Alarm calendar component is a grouping of component
  # properties that is a reminder or alarm for an event or a
  # to-do. For example, it may be used to define a reminder for a
  # pending Event or an overdue Todo.  
  class Alarm < Component
  
    # Single properties
    ical_property :action
    ical_property :description
    ical_property :trigger
    ical_property :summary
    
    # Single but must appear together
    ical_property :duration
    ical_property :repeat
    
    # Single and only occurring once
    
    ical_property :created
    ical_property :last_modified
    ical_property :timestamp
    ical_property :sequence

    # Multi properties
    ical_multiline_property :attendee, :attendee, :attendees
    ical_multiline_property :attach, :attachment, :attachments

    def initialize()
      super("VALARM")
      
      # Almost everyone just wants to display so I make it the 
      # default so it works for most people right away...
      action "DISPLAY"
    end
  end
end