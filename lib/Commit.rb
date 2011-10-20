require 'rubygems'
require 'data_mapper'
require 'net/http'
require 'json'
require 'uri'

# This will probably blow away the database, so regenerate on each request!
# Caching is not really possible since the content of each page will change
# page=1 always being the most recent.
class Commit < BaseModel

  def initialize(json_data)
    @json = json_data
  end

  def to_ical
    dtstart = DateTime.parse(@json['committed_date']).new_offset(0)
    dtstamp = DateTime.now.new_offset(0)
    url = "https://github.com%s" % @json["url"]
    summary = "Commit by %s (%s)" % [@json["author"]["name"], @json["author"]["email"]]

    (<<-EOF).remove_indent + "\n"
      BEGIN:VEVENT
      SEQUENCE:1
      TRANSP:OPAQUE
      UID:#{@json["id"]}
      DTSTART:#{dtstart.ical_timestamp}
      DTSTAMP:#{dtstamp.ical_timestamp}
      SUMMARY:#{summary}
      DESCRIPTION:#{@json['message'].gsub(/\n/,'\n')}
      CREATED:#{dtstamp.ical_timestamp}
      DTEND:#{(dtstart + 1/48.0).ical_timestamp}
      LOCATION:#{url}
      END:VEVENT
    EOF
  end

  def self.find_for(repo_obj, branch_name, get_all=false)
    commits, page_num = [], 1
    loop do
      jsonstr = get_json_response(github_api_url(repo_obj.owner, repo_obj.name,
                                                 branch_name, page_num)).body
      objs = JSON.parse(jsonstr)
      break if objs["error"]
      objs["commits"].each { |commit| commits << Commit.new(commit) }
      get_all ? page_num += 1 : break
    end
    commits
  end

  def self.github_api_url(username, reponame, branch=nil, page_num=nil)
    COMMITS_BASE_URL + ("%s/%s/%s?page=%d" % [username, reponame,
                                              branch || "master", page_num || 1])
  end

  def self.get_json_response(url)
    Net::HTTP.get_response(URI.parse(url))
  end
end


