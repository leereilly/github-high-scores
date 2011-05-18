require 'rubygems'
require 'data_mapper'
require 'net/http'
require 'json'
require 'uri'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'sqlite:////Users/lreilly/Projects/github-scores.com/db/db.db')

class User
  include DataMapper::Resource
  
  API_VERSION = 'v2'
  BASE_URL = 'http://github.com/api/' + API_VERSION + '/json/user/show/'
  
  property :id, Serial
  property :github_id, String
  property :gravatar_id, String
  property :login, String
  property :email, String  
  property :name, String  
  property :blog, String  
  property :company, String
  property :location, String
  property :type, String
  property :permission, String
  property :created_at, String
  property :public_repo_count, String
  property :public_gist_count, String
  property :following_count, String
  property :followers_count, String
  property :updated_at, DateTime
  

  def self.create_from_username(username)
    if found_user = User.first(:login => username)    
      if Time.now - Time.parse(found_user.updated_at.to_s) <= 60*60*24
        puts "User created less than 24 hours ago. Returning DB record"
        return found_user
      else
        puts "Updating current user"
        user = found_user
      end
    else
      puts "User not found; using web services"
      user = User.new
    end
    
    user_data_url = User.get_user_data_url(username)
    user_data_response = get_json_response(user_data_url)
    user_data = JSON.parse(user_data_response.body)
    user_data = user_data['user']
    
    user.github_id = user_data['id']
    user.gravatar_id = user_data['gravatar_id']
    user.login = user_data['login']
    user.email = user_data['email']
    user.name = user_data['name'] 
    user.blog = user_data['blog']
    user.company = user_data['company']
    user.location = user_data['location']
    user.type = user_data['type']
    user.permission = user_data['permission']
    user.created_at = user_data['created_at']
    user.public_repo_count = user_data['public_repo_count']
    user.public_gist_count = user_data['public_gist_count']
    user.following_count = user_data['following_count']
    user.followers_count = user_data['followers_count']
    user.updated_at = Time.now
    user.save!
    return user
  end
  
  def self.get_json_response(url)
    Net::HTTP.get_response(URI.parse(url))
  end

  def self.get_user_data_url(username)
    return BASE_URL + username
  end
end

DataMapper::auto_upgrade!
