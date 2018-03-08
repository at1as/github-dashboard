require 'httparty'
require 'json'

URL = "https://api.github.com/users/at1as/repos?per_page=100"
AUTH = {
  :username => ENV["GHNAME"],
  :password => ENV["GHPWD"]
}

def format_title(raw_string)
  raw_string.gsub! '_', '  '
  raw_string.gsub! '-', '  '
  raw_string.split(' ').map{ |x| x[0].capitalize + x[1..x.length - 1] }.join(' ')
end


SCHEDULER.every '30m', :first_in => 0 do
  stars      = {}
  stars_list = []

  repos = JSON.parse(HTTParty.get(URL, :basic_auth => AUTH).body)
  repos.each do |repo|
    stars[format_title(repo["name"])] = repo["stargazers_count"]
  end

  stars.sort_by {|k, v| -v }.to_h.each do |name, count|
    stars_list << {
      label: name,
      value: count
    }
  end

  send_event('stars', { items: stars_list[0...15] })
end
