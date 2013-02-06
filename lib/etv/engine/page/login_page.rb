require 'etv/engine/cookie_helper'
require 'etv/engine/page/access_page'

class LoginPage < Page
  LOGIN_URL = "https://secure.etvnet.com/login/"

  def initialize cookie_file_name, creds_collector
    @cookie_helper = CookieHelper.new cookie_file_name
    @creds_collector = creds_collector
  end

  def login username, password
    accessor.get_cookie LOGIN_URL, username, password
  end

  def get_cookie *params
    old_cookie = @cookie_helper.load_cookie

    cookie = old_cookie

    while cookie.nil? or cookie.expired?
      username, password = *@creds_collector.call(*params)

      cookie = Cookie.new login(username, password)
    end

    @cookie_helper.save_cookie cookie if cookie != old_cookie

    cookie
  end

end
