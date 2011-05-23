require 'rubygems'
require 'data_mapper'
require 'net/http'
require 'json'
require 'uri'

DataMapper::Logger.new($stdout, :debug)
puts "mysql://#{ENV['db_user']}:#{ENV['db_pass']}@#{ENV['db_host']}/#{ENV['db_data']}"
DataMapper.setup(:default, "mysql://#{ENV['db_user']}:#{ENV['db_pass']}@#{ENV['db_host']}/#{ENV['db_data']}")

class Contributor
  include DataMapper::Resource
  
  API_VERSION = 'v2'
  BASE_URL = 'http://github.com/api/' + API_VERSION + '/json/user/show/'
  
  property :id, Serial
  property :login, String
  property :gravatar_id, String
  property :contributions, String
  
  def self.create_from_user_and_repo(user, repo)
    stored_user = User::create_from_username(user)
    stored_repo = Repo::create_from_username_and_repo(user, repo)
    
    contributors_url = "http://github.com/api/v2/json/repos/show/#{user}/#{repo}/contributors"
    contributors_feed = Net::HTTP.get_response(URI.parse(contributors_url))
    contributors = contributors_feed.body
    contributors_result = JSON.parse(contributors)
    repository_contributors =  contributors_result['contributors']
    contributors_array = Array.new
   
    repository_contributors.each do |repository_contributor|
      contributor = Contributor.new
      contributor.login = repository_contributor['login']
      contributor.gravatar_id = repository_contributor['gravatar_id']
      contributor.contributions = repository_contributor['contributions']
      contributor.save
    end    
  end
  
  def self.get_json_response(url)
    Net::HTTP.get_response(URI.parse(url))
  end
end

DataMapper::auto_upgrade!
contributors = Contributor::create_from_user_and_repo('leereilly', 'leereilly.net')

