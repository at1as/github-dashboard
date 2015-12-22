require 'dashing'
require 'httparty'
require 'json'

configure do
  set :auth_token, 'YOUR_AUTH_TOKEN'

  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end

    def title(raw_string)
      raw_string.gsub! '_', '  '
      raw_string.gsub! '-', '  '
      raw_string.split(' ').map{ |x| x.capitalize }.join(' ')
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
