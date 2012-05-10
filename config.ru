require './lib/initializer'
require './lib/rack_app'
require './lib/mail_defaults'

use Rack::Static, 
  :urls => ["/assets", "/images"],
  :root => "public"
  
use Rack::Reloader, 0

run RackApp