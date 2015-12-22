require 'httparty'
require 'json'

auth = {:username => ENV["GHNAME"], :password => ENV["GHPWD"]}

SCHEDULER.every '1800s' do

  repo_details = JSON.parse(HTTParty.get('https://api.github.com/users/at1as/repos', :basic_auth => auth).body)
  repo_num = repo_details.length

  send_event('repos', { current: repo_num, last: 0 })
end
