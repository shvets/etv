require 'cgi'

require 'etv/engine/page/catalog_page'

class SearchPage < CatalogPage
  SEARCH_URL = BASE_URL + "/search/"

  def initialize(params)
    super("#{SEARCH_URL}?q=#{CGI.escape(*params)}")
  end

end
