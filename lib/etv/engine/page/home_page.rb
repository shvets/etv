require 'etv/engine/page/items_page'
require 'etv/engine/item/media_item'
require 'haml'

class HomePage < ItemsPage

  def items
    list = []

    document.css(".main-item-menu a").each do |item|
      text = item.text.strip
      href = item['href']

      unless href == '/' or href =~ /(freeTV|prices|helpTV|help)/
        list << MediaItem.new(text, href)
      end
    end

    list << MediaItem.new("Audio", "/audio")

    list
  end
  
end
