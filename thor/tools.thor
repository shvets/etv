
#require 'script_executor/executable'

require 'rack'

class Tools < Thor
  #include Executable

  desc "etv_web_grab", "etv_web_grab"
  def etv_web_grab
    $: << File.expand_path("lib")

    require 'etv/web_grab/app.rb'

    Rack::Handler::WEBrick.run(WebGrab::App, :Host => '127.0.0.1', :Port => '9292') do |server|
      [:INT, :TERM].each { |sig| trap(sig) { server.stop } }
    end
  end

end