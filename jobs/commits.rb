require 'httparty'
require 'json'
require 'date'

URL = "https://api.github.com/users/at1as/repos?per_page=100"
AUTH = {
  :username => ENV["GHNAME"],
  :password => ENV["GHPWD"]
}

def days_ago(date_string)
  today = DateTime.now
  year_month_day = date_string.split('-').map(&:to_i)

  DateTime.new(today.year, today.month, today.day, 0, 0, 0) - DateTime.new(year_month_day[0], year_month_day[1], year_month_day[2], 0, 0, 0)
end

SCHEDULER.every '30m', :first_in => 1000 do
  
  commit_urls = []
  points      = []

  commits     = {}
  0.upto(364) { |days_ago| commits[days_ago] = 0 }

  # Get link to each repos languages URL
  repos = JSON.parse(HTTParty.get(URL, :basic_auth => AUTH).body)
  repos.each { |repo| commit_urls << repo["commits_url"].gsub("{/sha}", "") }

  # Get hash of languages linecount for each repo
  commit_urls.each do |url|
    commit_body = JSON.parse(HTTParty.get(url, :basic_auth => AUTH).body)

    commit_body.each do |commit|
      commit_date = commit["commit"]["committer"]["date"].split('T').first
      
      if (day = days_ago(commit_date).to_i) < 365
        commits[day] += 1
      end
    end
  end

  commits.each do |commit_date, commit_num|
    points << {
      x: commit_date,
      y: commit_num
    }
  end

  send_event('commits', points: points)
end

