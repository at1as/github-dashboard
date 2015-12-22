require 'httparty'
require 'json'

auth = {:username => ENV["GHNAME"], :password => ENV["GHPWD"]}

SCHEDULER.every '3600s' do
  code = {}
  code_urls = []
  code_list = []
  
  repo_details = JSON.parse(HTTParty.get('https://api.github.com/users/at1as/repos', :basic_auth => auth).body)
  repo_details.each do |repo| 
    code_urls << repo["name"] = repo["languages_url"]
  end
  
  code_urls.each do |url|
    languages = JSON.parse(HTTParty.get(url, :basic_auth => auth).body)
    code.merge!(languages) { |key, old_val, new_val| old_val + new_val }
  end

  code.sort_by {|k, v| v }.reverse.to_h.each do |lang, bytes|
    code_list << { label: lang, value: bytes }
  end

  send_event('code', { items: code_list[0...15] })
end
