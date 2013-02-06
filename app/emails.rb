# encoding: utf-8

module Brt
  class Emails < App

    configure do
      enable :inline_templates
    end

    #
    # Disallow the admin area for non authorized users.
    #
    before do
      not_found unless has_admin?
    end

    #
    # GET /
    #
    get '/' do
      count, emails = Email.paginated(page: current_page, per_page: 20)
      slim :index, locals: {
        items: emails, page: current_page, page_count: count
      }
    end

    #
    # GET /:id
    #
    get '/:id' do |id|
      slim :view, locals: { item: Email.get(id) }
    end

  end
end


__END__


/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ index
section#emails
  header.row
    h2 E-Mails

  table.width-100.striped
    thead
      tr
        th.date Datum
        th colspan="2" Kontakt
    tfoot
      tr
        td colspan="3" == slim :_pagination, locals: { page_count: page_count, url: Email.link, page: page }
    tbody
      - for item in items
          tr
            td.date = item.date_formatted
            td
              a.gray-dark href="mailto:#{item.email}" #{item.name} &lt;#{item.email}&gt;
            td
              a.icons href="#{item.editlink}" &#x22;


/ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
@@ view
section#email
  header.row
    section.twothird
      a.gray-dark href="mailto:#{item.email}" #{item.name} &lt;#{item.email}&gt;
    section.third.date = item.date_formatted('%-d. %B %Y')

  article.row == item.message_formatted
