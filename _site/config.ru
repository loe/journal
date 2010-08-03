require 'yaml'
require 'rack/jekyll'
require 'rack/rewrite'

use Rack::Rewrite do
  r301 '/feed', 'http://feeds.andrewloe.com/WALoeIII-Journal'
end

run Rack::Jekyll.new