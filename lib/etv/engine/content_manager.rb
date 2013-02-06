require 'etv/engine/items_page_factory'

class ContentManager

  def get_items mode, *params
    page = ItemsPageFactory.create mode, *params

    page.items
  end

end
