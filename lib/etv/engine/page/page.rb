require 'nokogiri'
require 'resource_accessor/resource_accessor'

class Page
  BASE_URL = "http://etvnet.com"

  attr_reader :url, :document, :accessor

  def initialize(url = "#{BASE_URL}/")
    @url = (url.index(BASE_URL).nil? ? "#{BASE_URL}/#{url}" : url)
    @accessor = ResourceAccessor.new
  end

  def load_page
    response = accessor.get_response :url => "#{url}"

    @document = Nokogiri::HTML(response.body)
  end

end
