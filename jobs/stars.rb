require 'httparty'
require 'json'


def title(raw_string)
  raw_string.gsub! '_', '  '
  raw_string.gsub! '-', '  '
  raw_string.split(' ').map{ |x| x[0].capitalize + x[1..x.length - 1] }.join(' ')
end

auth = {:username => ENV["GHNAME"], :password => ENV["GHPWD"]}


SCHEDULER.every '1800s' do
  stars = {}
  stars_list = []

  repo_details = JSON.parse(HTTParty.get('https://api.github.com/users/at1as/repos', :basic_auth => auth).body)
  repo_details.each do |repo| 
    stars[title(repo["name"])] = repo["stargazers_count"]
  end
  
  stars.sort_by {|k, v| v }.reverse.to_h.each do |name, count|
    stars_list << { label: name, value: count }
  end

  send_event('stars', { items: stars_list[0...15] })
end
