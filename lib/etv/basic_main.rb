require "highline/import"
require 'etv/engine/page/login_page'
require 'etv/engine/page/access_page'
require 'etv/engine/item/media_item'

class BasicMain
  COOKIE_FILE_NAME = "#{ENV['HOME']}/.etv"
  CREDENTIALS_FILE_NAME = "#{ENV['HOME']}/.etv_credentials"

  def initialize
    @login_page = LoginPage.new COOKIE_FILE_NAME, lambda { get_credentials }
    @access_page = AccessPage.new
  end

  def read_from_file file_name
    File.open(file_name, 'r') { |file| file.readlines.join("/n") }
  end

  def write_to_file file_name, content
    File.open(file_name, 'w') { |file| file.write content }
  end

  def get_credentials
    file_name = CREDENTIALS_FILE_NAME

    if File.exist? file_name
      content = StringIO.new read_from_file file_name

      username = content.readline.split(":")[1].chomp
      password = content.readline.split(":")[1].chomp
    else
      username, password = ask_credentials

      write_to_file file_name, "username: #{username}\npassword: #{password}"
    end

    [username, password]
  end

  def ask_credentials
    username = ask("Enter username :  ")
    password = ask("Enter password : ") { |q| q.echo = '*' }

    [username, password]
  end

  def build_media_item query, media_id
    url = (query == media_id) ? "http://etvnet.com/tv/watch/#{media_id}/" : query

    page = Page.new(url)
    page.load_page

    text = page.document.css(".info-movie-title h1").text.strip

    name = text ? text : query

    MediaItem.new(name, media_id)
  end

  def request_link query
    cookie = @login_page.get_cookie

    media_id = @access_page.locate_media_id query

    @access_page.request_link_info build_media_item(query, media_id), cookie.value
  end

end
