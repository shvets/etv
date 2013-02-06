require 'etv/engine/page/home_page'
require 'etv/engine/page/live_page'
require 'etv/engine/page/channels_page'
require 'etv/engine/page/catalog_page'
require 'etv/engine/page/media_page'
require 'etv/engine/page/search_page'
require 'etv/engine/page/best_hundred_page'
require 'etv/engine/page/top_this_week_page'
require 'etv/engine/page/premiere_page'
require 'etv/engine/page/new_items_page'
require 'etv/engine/page/audio_page'
require 'etv/engine/page/radio_page'

class ItemsPageFactory
  def self.create mode, params = []
    url = (mode == 'search') ? nil : (params.class == String ? params : params[0])

    case mode
      when 'main' then
        page = HomePage.new
      when 'live' then
        page = LivePage.new
      when 'channels' then
        page = ChannelsPage.new
      when 'catalog' then
        page = CatalogPage.new
      when 'media' then
        page = MediaPage.new url
      when 'search' then
        page = SearchPage.new *params
      when 'best_hundred' then
        page = BestHundredPage.new
      when 'top_this_week' then
        page = TopThisWeekPage.new
      when 'premiere' then
        page = PremierePage.new
      when 'new_items' then
        page = NewItemsPage.new
      when 'audio' then
        page = AudioPage.new
      when 'radio' then
        page = RadioPage.new
      else
        page = nil
    end

    page.load_page

    page
  end

end
