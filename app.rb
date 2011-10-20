$:.unshift File.join(File.dirname(__FILE__),'lib')

require 'rubygems'
require 'net/http'
require 'sinatra'
require 'json'
require 'erb'
require 'uri'
require 'data_mapper'
require 'dm-migrations'

DataMapper::Logger.new($stdout, :debug)
dburl = case ENV['db_use']
        when 'mysql' then ("mysql://#{ENV['db_user']}:#{ENV['db_pass']}@"+
                           "#{ENV['db_host']}/#{ENV['db_data']}")
        when 'sqlite' then "sqlite3://#{ENV['db_path']}"
        when 'sqlite_default' then "sqlite3://#{Dir.pwd}/db/my.db"
        else
          puts "REQUIRED: please provide a value for db_use -- see README.md"
          exit
        end
DataMapper.setup(:default, dburl)

require 'helpers'
require 'User'
require 'Repo'

disable :show_exceptions
set :environment, :production

error do
  @title = "404"
  @text = "Sorry, but this cat is in another castle!"
  @display_small_search = false
  erb :not_found
end

get '/' do
  begin
    if params[:github_url]
      @title = 'High Scores'
      @github_url = sanitize_input params[:github_url]
      @user = get_user_from_github_url(@github_url)
      @repo = get_repo_from_github_url(@github_url)
      @high_scores = get_high_scores(@user, @repo)
      @display_small_search = true
      redirect "/#{@user}/#{@repo}/high_scores/"
    else
      @title = 'High Scores'
      @text = 'Please enter a Github repository URL'
      @display_small_search = false
      erb :index
    end
  rescue
    @title = "404"
    @text = "Sorry, but this cat is in another castle!"
    @display_small_search = false
    erb :not_found
  end
end

get '/recent_searches/?' do
   @repos = Repo.all(:limit => 5, :order => [ :updated_at.desc ])
   @display_small_search = true
   erb :recent_searches
end

get '/credits/?' do
  erb :credits
end

get '/help/?' do
  @display_small_search = true
  erb :help
end

get '/about/?' do
  @display_small_search = true
  erb :about
end

get '/:user/:repo/?' do
  @user = User::create_from_username(params[:user])
  @repo = Repo::create_from_username_and_repo(params[:user], params[:repo])
  @display_small_search = true
  erb :repo
end

get '/:user/?' do
  @user = User::create_from_username(params[:user])
  @display_small_search = true
  erb :user
end

not_found do
  @title = "404"
  @text = "Sorry, but this cat is in another castle!"
  erb :not_found
end

def sanitize_input(url)
  url = url.downcase

  # Special rules for Github URLs starting with 'github.com'
  if url[0..9] == 'github.com'
    url = 'https://www.github.com' + url[9..url.size]

  # Special rules for Github URLs starting with 'www.github.com'
  elsif url[0..13] == 'www.github.com'
    url = 'https://www.github.com' + url[13..url.size]
  end

  # Special rules for Github URLs ending in 'git'
  if url[-4,4] == '.git'
    url = url[0..-5]
  end

  url = url.gsub("http://", "https://")
  url = url.gsub("git@github.com:", "https://www.github.com/")
  url = url.gsub("git://", "https://www.")

  # If someone just passes in user/repo e.g. leereilly/leereilly.net
  tokens = url.split('/')
  if tokens.size == 2
    url = "https://www.github.com/#{tokens[0]}/#{tokens[1]}"
  end

  return url
end

def get_user_from_github_url(sanitized_github_url)
  return sanitized_github_url.split('/')[3]
end

def get_repo_from_github_url(sanitized_github_url)
  return sanitized_github_url.split('/')[4]
end

def get_high_scores(user, repo)
  begin
    # Kludge - three API calls
    stored_user = User::create_from_username(user)
    puts "Storing user: #{stored_user}"
    stored_repo = Repo::create_from_username_and_repo(user, repo)
    puts "Storing repo: #{stored_repo}"

    contributors_url = "http://github.com/api/v2/json/repos/show/#{user}/#{repo}/contributors"

    contributors_feed = Net::HTTP.get_response(URI.parse(contributors_url))
    contributors = contributors_feed.body
    contributors_result = JSON.parse(contributors)
    repository_contributors =  contributors_result['contributors']
    contributors_array = Array.new
    repository_contributors.each do |repository_contributor|
      user_hash = Hash.new
      user_hash[:login] = repository_contributor['login']
      user_hash[:name] = repository_contributor['name']
      user_hash[:email] = repository_contributor['email']
      user_hash[:gravatar_id] = repository_contributor['gravatar_id']
      user_hash[:location] = repository_contributor['location']
      user_hash[:contributions] = repository_contributor['contributions'].to_i
      contributors_array << user_hash
    end
    return contributors_array
  rescue
    raise "Sorry, this GitHub repository doesn't seem to exist or is private"
  end
end


get '/:user/:repo/high_scores/?' do
  @title = "New"
  @user = params[:user]
  @repo = params[:repo]
  @high_scores = get_high_scores(@user, @repo)
  @display_small_search = true
  erb :high_scores
end
