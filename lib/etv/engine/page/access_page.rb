require 'json'

require 'etv/engine/page/page'
require 'etv/engine/link_info'
require 'resource_accessor/resource_accessor'

class AccessPage < Page
  ARCHIVE_URL = "#{Page::BASE_URL}/tv/watch/"

  def request_link_info item, cookie
    #cookie.gsub!("\"", "\"\"")

    if item.link =~ /\/live\//
      link = "#{Page::BASE_URL}#{item.link}"
      response = accessor.get_ajax_response(:url => link, :cookie => cookie)
    else
      link = "#{ARCHIVE_URL}#{locate_media_id(item.link)}/"

      response = accessor.get_response :url => link, :method => :post, :cookie => cookie,
                                       :body => {:bitrate => 2, :view => "submit"}
    end

    if response
      json = JSON.parse(response.body)

      message = json['msg']
      url = json["url"]

      if url
        LinkInfo.new(item, url)
      else
        raise "Problem getting url: #{message}"
      end
    end

  end

  def locate_media_id string
    if string =~ /^\d+$/
      string
    else
      string.scan(/.*\/(\d*)\//)[0][0]
    end
  end

end
