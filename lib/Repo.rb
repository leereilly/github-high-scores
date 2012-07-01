require 'rubygems'
require 'data_mapper'
require 'json'
require 'uuidtools'

class Repo < BaseModel
  include DataMapper::Resource

  property :id, Serial, :lazy => false
  property :owner, Text, :lazy => false
  property :url, Text, :lazy => false
  property :homepage, Text, :lazy => false
  property :name, Text, :lazy => false
  property :description, Text  , :lazy => false
  property :parent, Text, :lazy => false
  property :has_issues, Text, :lazy => false
  property :source, Text, :lazy => false
  property :watchers, Text, :lazy => false
  property :has_downloads, Text, :lazy => false
  property :fork, Text, :lazy => false
  property :forks, Text, :lazy => false
  property :has_wiki, Text, :lazy => false
  property :pushed_at, Text, :lazy => false
  property :open_issues, Text, :lazy => false
  property :updated_at, DateTime, :lazy => false

  def self.create_from_username_and_repo(username, repo)
    repo_data_url = Repo.get_repo_data_url(username, repo)

    if found_repo = Repo.first(:owner => username, :name => repo)
      if Time.now - Time.parse(found_repo.updated_at.to_s) <= 60*60*24
        return found_repo
      else
        repo = found_repo
      end
    else
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
    RestClient.get(url)
  end

  def self.get_repo_data_url(username, repo)
    return REPO_BASE_URL + username + '/' + repo
  end
end

DataMapper.auto_upgrade!

