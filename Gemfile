source "http://rubygems.org"

unless File.exist?("/usr/local/Cellar/ffmpeg")
  system "brew update"
  system "brew install ffmpeg"
  system "brew install mplayer"
  system "brew install ffmpeg imagemagick ghostscript libtool"
end

gem "smart_specs"
gem "resource_accessor"

gem "storyboard"
gem "nokogiri"
gem "libxml-ruby"
gem "json_pure"
gem "ruby-progressbar"

gem "sinatra"
gem "sinatra-partial"
gem "haml"
gem "sass"
gem "rack"
gem "launchy"
gem "vegas"
gem "russian"

group :development do
  gem "script_executor"
  gem "thor"
  gem "gemspec_deps_gen"
  gem "gemcutter"

  gem "highline"
end

group :test do
  gem "rspec"
  gem "mocha"
end






