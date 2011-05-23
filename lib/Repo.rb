require 'rubygems'
require 'data_mapper'
require 'net/http'
require 'json'
require 'uri'

DataMapper::Logger.new($stdout, :debug)
puts "mysql://#{ENV['db_user']}:#{ENV['db_pass']}@#{ENV['db_host']}/#{ENV['db_data']}"
DataMapper.setup(:default, "mysql://#{ENV['db_user']}:#{ENV['db_pass']}@#{ENV['db_host']}/#{ENV['db_data']}")

class Repo
  include DataMapper::Resource
  
  API_VERSION = 'v2'
  BASE_URL = 'http://github.com/api/' + API_VERSION + '/json/repos/show/'

  property :id, Serial
  property :owner, Text
  property :url, Text
  property :homepage, Text
  property :name, Text
  property :description, Text  
  property :parent, Text  
  property :has_issues, Text  
  property :source, Text
  property :watchers, Text  
  property :has_downloads, Text
  property :fork, Text
  property :forks, Text
  property :has_wiki, Text
  property :pushed_at, Text
  property :open_issues, Text
  property :updated_at, DateTime
  
  def self.create_from_username_and_repo(username, repo)
    repo_data_url = Repo.get_repo_data_url(username, repo)
    
    if found_repo = Repo.first(:owner => username, :name => repo)    
      if Time.now - Time.parse(found_repo.updated_at.to_s) <= 60*60*24
        puts "Repo created less than 24 hours ago. Returning DB record"
        return found_repo
      else
        puts "Updating current repo"
        repo = found_repo
      end
    else
      puts "User not found; using web services"
      repo = Repo.new
    end
    
    repo_data_response = get_json_response(repo_data_url)
    repo_data = JSON.parse(repo_data_response.body)
    repo_data = repo_data['repository']
    
    repo.owner = repo_data['owner']
    repo.name = repo_data['name']
    repo.url = repo_data['url']
    repo.homepage = repo_data['homepage']
    repo.description = repo_data['description']
    repo.parent = repo_data['parent']
    repo.has_issues = repo_data['has_issues']
    repo.source = repo_data['source']
    repo.watchers = repo_data['watchers']
    repo.has_downloads = repo_data['has_downloads']
    repo.fork = repo_data['fork']
    repo.forks = repo_data['forks']
    repo.has_wiki = repo_data['has_wiki']
    repo.pushed_at = repo_data['pushed_at']
    repo.open_issues = repo_data['open_issues']     
    repo.updated_at = Time.now   
    repo.save!
    return repo
  end
  
  def self.get_json_response(url)
    Net::HTTP.get_response(URI.parse(url))
  end

  def self.get_repo_data_url(username, repo)
    return BASE_URL + username + '/' + repo
  end
end

DataMapper.auto_migrate!

