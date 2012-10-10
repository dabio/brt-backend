# encoding: utf-8

module Brt
  module Helpers

    # This gives us the currently logged in user. We keep track of that by just
    # setting a session variable with their is. If it doesn't exist, we want to
    # return nil.
    def current_person
      unless @cu
        @cu = Person.get(@request.session[:person_id]) if @request.session[:person_id]
      end
      @cu
    end

    # Checks if this is a logged in person
    def has_auth?
      !current_person.nil?
    end

    # Check if current person is logged in and is admin
    def has_admin?
      has_auth? && current_person.id == 1
    end

  end
end
