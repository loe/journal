require 'yaml'
require 'rack/pony'
require 'rack/jekyll'

use Rack::Pony
run Rack::Jekyll.new