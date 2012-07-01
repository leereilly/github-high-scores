require 'rubygems'
require 'data_mapper'
require 'json'
require 'rest-client'

class User < BaseModel
  include DataMapper::Resource

  property :id, Serial, :lazy => false
  property :github_id, Text, :lazy => false
  property :gravatar_id, Text, :lazy => false
  property :login, Text, :lazy => false
  property :email, Text, :lazy => false
  property :name, Text, :lazy => false
  property :blog, Text, :lazy => false
  property :company, Text, :lazy => false
  property :location, Text, :lazy => false
  property :type, Text, :lazy => false
  property :permission, Text, :lazy => false
  property :created_at, Text, :lazy => false
  property :public_repo_count, Text, :lazy => false
  property :public_gist_count, Text, :lazy => false
  property :following_count, Text, :lazy => false
  property :followers_count, Text, :lazy => false
  property :updated_at, DateTime, :lazy => false


  def self.create_from_username(username)
    if found_user = User.first(:login => username)
      if Time.now - Time.parse(found_user.updated_at.to_s) <= 60*60*24
        return found_user
      else
        user = found_user
      end
    else
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
    RestClient.get(url)
  end

  def self.get_user_data_url(username)
    return USER_BASE_URL + username
  end
end

DataMapper::auto_upgrade!