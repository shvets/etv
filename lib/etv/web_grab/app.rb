require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

require 'sinatra/base'
require 'sinatra/partial'
require 'haml'
require 'sass'

require 'etv/engine/items_page_factory'

require 'etv/basic_main'

module WebGrab
  class App < Sinatra::Base
    register Sinatra::Partial

    COOKIE_FILE_NAME = ENV['HOME'] + "/.etv"

    set :haml, {:format => :html5, :attr_wrapper => '"'}
    set :views, File.dirname(__FILE__) + '/app/views'
    set :public_folder, File.dirname(__FILE__) + '/app/public'
    set :sessions, true
    enable :partial_underscores
    #set :partial_template_engine, :erb

    def initialize app=nil
      super

      @basic_main = BasicMain.new
    end

    get '/javascripts/*' do
      open("#{File.dirname(__FILE__)}/../public/javascripts/#{params[:splat]}")
    end

    get '/stylesheet.css' do
      headers 'Content-Type' => 'text/css; charset=utf-8'
      sass :stylesheet
    end

    get '/' do
      haml :index
    end

    get '/grab/' do
      query = unescape request.fullpath.gsub("/grab/?q=", "")

      link_info = @basic_main.request_link query

      link = link_info.link
      name = link_info.media_item.text
      name =  link_info.media_item.underscore_name if name.nil? or name.strip.size == 0

      haml :grab, :locals => {:query => query, :link => link, :name => name}
    end

    helpers do
      include Rack::Utils

      alias_method :h, :escape_html
    end

  end
end
