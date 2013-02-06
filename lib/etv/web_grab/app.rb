require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

require 'sinatra/base'
require 'haml'
require 'sass'

require 'etv/web/partial'

require 'etv/engine/items_page_factory'
require 'etv/engine/page/login_page'

module GrabWeb
  class App < Sinatra::Base
    COOKIE_FILE_NAME = ENV['HOME'] + "/.etv"

    set :haml, {:format => :html5, :attr_wrapper => '"'}
    set :views, File.dirname(__FILE__) + '/app/views'
    set :public_folder, File.dirname(__FILE__) + '/app/public'
    set :sessions, true

    def initialize app=nil
      super
    end

    #def login
    #  session[:original_path] = request.path_info
    #  redirect "/login"
    #end

    get '/javascripts/*' do
      open("#{File.dirname(__FILE__)}/../public/javascripts/#{params[:splat]}")
    end

    get '/stylesheet.css' do
      headers 'Content-Type' => 'text/css; charset=utf-8'
      sass :stylesheet
    end

    #get '/login' do
    #  haml :login, :layout => :login_layout
    #end
    #
    #post "/login" do
    #  login_page = LoginPage.new COOKIE_FILE_NAME, lambda { login }
    #  login_page.login request[:username], request[:pwd]
    #
    #  redirect session[:original_path]
    #end

    get '/grab' do
      url = request.fullpath

      page = ItemsPageFactory.create("media", url)

      if page.items.size > 0
        haml :display_container_items, :locals => {:page => page}
      else
        name = page.document.css(".info-movie-title h1").text
        current_item = BrowseMediaItem.new(name, request.path_info)

        login_page = LoginPage.new COOKIE_FILE_NAME, lambda { login }

        cookie = login_page.get_cookie session, request

        access_page = AccessPage.new

        result = access_page.request_link_info current_item, cookie.value

        if result
          haml :display_media, :locals => {:page => page, :link_info => result}
        end
      end
    end

    #helpers do
    #  include Partial
    #  include Rack::Utils
    #
    #  alias_method :h, :escape_html
    #
    #  def display_link_or_folder item
    #    result = "<a href='#{item.link}'>#{item.text}</a>"
    #
    #    if item.folder?
    #      "{#{result}}..."
    #    else
    #      result
    #    end
    #  end
    #
    #  def display_link_or_text item
    #    if item.link
    #      result = "<a href='#{item.link}'>#{item.text}</a>"
    #
    #      item.additional_info ? result + item.additional_info : result
    #    else
    #      item.text
    #    end
    #  end
    #end
  end
end
