require 'etv/engine/cookie'

class CookieHelper
  
  def initialize cookie_file_name
    @cookie_file_name = cookie_file_name
  end

  def load_cookie
    File.exist?(@cookie_file_name) ? Cookie.new(read_from_file(@cookie_file_name)) : nil
  end

  def save_cookie cookie
    return if cookie.nil?

    write_to_file @cookie_file_name, cookie.value
  end

  def delete_cookie
    File.delete @cookie_file_name if File.exist? @cookie_file_name
  end

  private
  
  def read_from_file file_name
    File.open(file_name, 'r') { |file| file.readlines.join("/n") }
  end

  def write_to_file file_name, content
    File.open(file_name, 'w') { |file| file.write content }
  end
end
