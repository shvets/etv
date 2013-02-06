require 'rubygems' unless RUBY_VERSION =~ /1.9.*/

$:.unshift(File::join(File::dirname(__FILE__)), "lib")

#
#trap(:INT) { exit }
#
#app = Rack::Builder.new {
# use Rack::CommonLogger
# run App
#}.to_app
#
#run app


# To use with thin
#  thin start -p PORT -R config.ru

require 'etv/web/app'

trap(:INT) { exit }

app = Rack::Builder.new {
  use Rack::CommonLogger
  run Web::App
}.to_app

run app

if ENV['launchy']
  require 'launchy'

  Launchy::Browser.run("http://localhost:9292")
end

