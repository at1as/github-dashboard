require 'httparty'
require 'json'

URL = "https://api.github.com/users/at1as/repos?per_page=100"
AUTH = {
  :username => ENV["GHNAME"],
  :password => ENV["GHPWD"]
}

SCHEDULER.every '30m', :first_in => 0 do
  code      = {}
  code_urls = []
  code_list = []
  
  repos = JSON.parse(HTTParty.get(URL, :basic_auth => AUTH).body)
  repos.each do |repo| 
    code_urls << repo["languages_url"]
  end
  
  code_urls.each do |url|
    languages = JSON.parse(HTTParty.get(url, :basic_auth => AUTH).body)
    
    code.merge!(languages) do |key, old_val, new_val|
      old_val + new_val
    end
  end

  puts code
  code.sort_by {|k, v| -v }.to_h.each do |lang, bytes|
    code_list << {
      label: lang,
      value: bytes
    }
  end

  send_event('code', { items: code_list[0...15] })
end
