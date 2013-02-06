require 'etv/engine/page/page'
require 'etv/engine/page/items_page'
require 'etv/engine/page/group_page'

class LivePage < ItemsPage
  CHANNELS_URL = Page::BASE_URL + "/live/"

  def initialize url = CHANNELS_URL
    super(url)
  end

  def items
    list = []

    document.css("#table-onecolumn-stream .odd").each do |item|
      text = item.children.at(0).text.strip

      links = item.css("td a")
      href = links[1]

      link = href.attributes['href'].value

      list << MediaItem.new(text, link)
    end

    list
  end

end
