$:.unshift File.join(File.dirname(__FILE__),'lib')

require 'rubygems'
require 'sinatra'
require 'octokit'

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
      redirect "/#{@user}/#{@repo}"
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
  @title = "New"
  @user = params[:user]
  @repo = params[:repo]
  @high_scores = get_high_scores(@user, @repo)
  @display_small_search = true
  erb :high_scores
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
    contributors = Octokit.contributors "#{user}/#{repo}"
  rescue Exception => e
    raise e.message
  end
end

# support legacy links
get '/:user/:repo/high_scores/?' do
  @title = "New"
  @user = params[:user]
  @repo = params[:repo]
  @high_scores = get_high_scores(@user, @repo)
  @display_small_search = true
  erb :high_scores
end
