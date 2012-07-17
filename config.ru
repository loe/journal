require 'bundler'
Bundler.require

use Rack::Rewrite do
  r301 '/feed', 'http://feeds.andrewloe.com/WALoeIII-Journal'
end

use Rack::ConditionalGet
use Rack::ETag, nil, 'public, max-age=600'
run Rack::Jekyll.new
