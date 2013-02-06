require 'script_executor'

require_relative 'spec_helper'

require 'json'
require 'resource_accessor/resource_accessor'
require 'etv/basic_main'

describe ResourceAccessor do

  let(:script_executor) { ScriptExecutor.new }

  before do
    cli = BasicMain.new

    @username, @password = cli.get_credentials
  end

  it "should get cookie and then retrieve response" do
    cookie = subject.get_cookie "https://secure.etvnet.com/login/", @username, @password

    puts "Cookie: #{cookie}"

    response = subject.get_response :url => "http://etvnet.com/tv/watch/151262/", :method => :post, :cookie => cookie,
                                    :body => { :bitrate => 2, :view => "submit" }
    puts response.body

    if response
      data_url = JSON.parse(response.body)["url"]

      puts "URL: #{data_url}"

      # script_executor.execute { vlc url, "test1.wmv" }
      # #script_executor.execute { mplayer url, "test1.wmv" }
    end
  end

  it "should get simple response" do
    response = subject.get_response :url => "http://www.etvnet.com/catalog/"

    response.should_not be_nil
  end

end

