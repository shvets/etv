class LinkInfo
  attr_reader :media_item

  def initialize(media_item, link)
    @media_item = media_item
    @link = link
  end

  def resolved?
    not @link.nil? and not @link.strip.size == 0
  end

  def text
    media_item.text
  end

  def name
    media_item.underscore_name
  end

  def media_file
    media_item.media_file
  end

  def link
    @link
  end

end