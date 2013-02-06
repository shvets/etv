require 'etv/engine/page/items_page'
require 'etv/engine/item/media_item'

class AudioPage < ItemsPage
  AUDIO_URL = Page::BASE_URL + "/audio/"

  def initialize url = AUDIO_URL
    super(url)
  end

  def items
    list = []

    document.css("#nav a").each do |item|
      text = item.css("span").text.strip
      href = item['href']

      unless href == '/' or href =~ /(press|register|persons)/
        list << MediaItem.new(text, href)
      end
    end

    list
  end

end
