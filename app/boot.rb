# encoding: utf-8

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined? RACK_ENV
ROOT_DIR = File.dirname(File.expand_path(__FILE__))

require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

# PostgreSQL
DataMapper::Logger.new($stdout, :debug) if RACK_ENV == 'development'
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://dan@localhost/brt')
#DataMapper.repository(:default).adapter.resource_naming_convention = DataMapper::NamingConventions::Resource::UnderscoredAndPluralizedWithoutModule

Dir[
  './lib/*.rb',
  './app/models/base.rb',
  './app/models/*.rb',
].each do |f|
  require f
end

# Finalize Datamapper Models
DataMapper.finalize

module Brt

  class Boot < Sinatra::Base
    use Rack::ForceDomain, ENV['DOMAIN']
    use Rack::Session::Cookie, secret: 'blah'
    use Rack::Protection

    register Sinatra::Flash
    register Sinatra::R18n

    configure do
      enable :method_override
      # enable :inline_templates

      set :root, ROOT_DIR
      set :public_folder, "#{ROOT_DIR}/../public"
      set :default_locale, 'de'
    end

    configure :production do
      disable :logging
    end

    configure :development do
      enable :logging
      enable :show_exceptions
    end

    configure :test do
      enable :raise_errors
      disable :logging
      disable :reload_templates
    end

    helpers do
      # Returns text transformed into HTML using simple formatting rules. Two or
      # more consecutive newlines(\n\n) are considered as a paragraph and wrapped
      # in <p> or your own tags. One newline (\n) is considered as a linebreak
      # and <br /> tag is appended.
      # This method does not remove the newlines from the text.
      def simple_format(text, options={})
        t = options.delete(:tag) || :p
        start_tag = "<#{t}>"
        text = text.to_s.dup
        text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
        text.gsub!(/\n\n+/, "</#{t}>\n\n#{start_tag}")  # 2+ newline  -> paragraph
        text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
        text.insert 0, start_tag
        text << "</#{t}>"
      end

      # Returns the current page given by the url request parameter. Defaults to
      # 1.
      def current_page
        params[:page] && params[:page].match(/\d+/) ? params[:page].to_i : 1
      end

      # This gives us the currently logged in user. We keep track of that by just
      # setting a session variable with their is. If it doesn't exist, we want to
      # return nil.
      def current_person
        unless @cp and @request.session[:person_id]
          @cp = Person.get(@request.session[:person_id])
        end
        @cp
      end

      # Checks if this is a logged in person
      def has_auth?
        !current_person.nil?
      end

      # Check if current person is logged in and is admin
      def has_admin?
        has_auth? && current_person.is_admin
      end

      def today
        Date.today
      end
    end

  end

end

Dir[
  './app/app.rb',
  './app/*.rb'
].each do |f|
  require f
end

