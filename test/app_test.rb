require 'rubygems'
require 'test/unit'
require 'rack/test'
require '../app'

ENV['RACK_ENV'] = 'test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_a_variety_of_urls_work
    valid_urls = [
      'http://www.github.com/leereilly/leereilly.net',
      'https://www.github.com/leereilly/leereilly.net',
      'git@github.com:leereilly/leereilly.net.git',
      'git://github.com/leereilly/leereilly.net.git',
      'github.com/leereilly/leereilly.net.git',
      'www.github.com/leereilly/leereilly.net.git',
      'leereilly/leereilly.net'
    ]
    valid_urls.each do |valid_url|
      get '/', params = {:github_url => valid_url}
      assert_equal last_response.status, 302
      follow_redirect!
      assert_equal last_response.status, 200
    end
  end

  def test_landing_page_works_as_expected
    get '/', params = {:github_url => 'http://www.github.com/leereilly/leereilly.net'}
    assert_equal last_response.status, 302
    follow_redirect!
    assert_equal last_response.status, 200
  end
  
  def test_search_redirected_to_seo_friendly_url
    
  end

  def test_cute_404_page
    get '/lee/lee/lee'
    assert_equal last_response.status, 404
    assert last_response.body.include? 'Sorry, but this cat is in another castle!'
  end

  def test_that_peeps_get_credit_where_credit_is_deserved
    get '/credits'
    assert last_response.ok?
    kudos_to = Array[
      'Ruby', 
      'Sinatra', 
      'Passenger', 
      'Dreamhost', 
      'Github', 
      'Lee Reilly',
      'Al Gore']
    kudos_to.pop
    kudos_to.each do |kudo_to|
      assert last_response.body.include?(kudo_to)
    end
  end
end