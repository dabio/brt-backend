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
        emails: emails, page: current_page, page_count: count, title: 'E-Mails'
      }
    end

    #
    # GET /:id
    #
    get '/:id' do |id|
      email = Email.get(id)
      erb :email, locals: { email: email, title: "E-Mail von #{email.name}" }
    end

  end
end
