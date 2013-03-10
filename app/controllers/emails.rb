# encoding: utf-8

module Brt
  class Emails < App

    #
    # Disallow the admin area for non authorized users.
    #
    before do
      authorize!
      not_found unless has_admin?
    end

    #
    # GET /
    #
    get '/' do
      count, emails = Email.paginated(page: current_page, per_page: 20)
      erb :emails, locals: {
        emails: emails, page: current_page, page_count: count
      }
    end

    #
    # GET /:id
    #
    get '/:id' do |id|
      erb :email, locals: { email: Email.get(id) }
    end

  end
end
