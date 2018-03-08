require 'httparty'
require 'json'

URL = "https://api.github.com/users/at1as/repos?per_page=100"
AUTH = {
  :username => ENV["GHNAME"],
  :password => ENV["GHPWD"]
}


SCHEDULER.every '30m', :first_in => 0 do
  repos = JSON.parse(HTTParty.get(URL, :basic_auth => AUTH).body)

  send_event('repos', {current: repos.length, last: 0})
end
