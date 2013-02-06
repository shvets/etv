require 'cgi'
require 'time'

class Cookie
  attr_reader :value

  def initialize value
    @value = value

    @expires ||= calculate_expires
  end

  def expired?
    @expires.nil? ? false : (Time.parse(@expires) < Time.now)
  end

  private

  def calculate_expires
    items = @value.split(";").collect do |item|
      key, value = item.split("=")

      [key.strip, value.strip]
    end

    expires = nil

    count = 0

    items.each do |key, value|
      if key == "expires"
        count += 1

        if count == 2
          expires = value
        end
      end
    end

    expires
  end
end
