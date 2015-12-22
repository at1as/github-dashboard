require 'httparty'
require 'json'
require 'date'

auth = {:username => ENV["GHNAME"], :password => ENV["GHPWD"]}
DAYS = 365

def days_ago(date_string)
  today = DateTime.now
  year_month_day = date_string.split('-').map { |x| x.to_i }

  DateTime.new(today.year, today.month, today.day, 0, 0, 0) - DateTime.new(year_month_day[0], year_month_day[1], year_month_day[2], 0, 0, 0)
end

SCHEDULER.every '300s' do
  
  commits = Hash.new(0) 
  (0..DAYS).each {|x| commits[x] = 0 }

  commit_urls = []
  points = []

  # Get link to each repos languages URL
  repo_details = JSON.parse(HTTParty.get('https://api.github.com/users/at1as/repos', :basic_auth => auth).body)
  repo_details.each { |repo| commit_urls << repo["commits_url"].gsub("{/sha}", "") }

  # Get hash of languages linecount for each repo
  commit_urls.each do |url|
    commit_body = JSON.parse(HTTParty.get(url, :basic_auth => auth).body)

    commit_body.each do |commit|
      commit_date = commit["commit"]["committer"]["date"].split('T').first
      
      if (day = days_ago(commit_date).to_i) < 365
        commits[day] += 1
      end
    end
  end

  commits.each do |commit_date, commit_num|
    points << { x: commit_date, y: commit_num}
  end

  send_event('commits', points: points)
end

