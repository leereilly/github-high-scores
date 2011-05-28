class BaseModel
  API_VERSION = 'v2'
  BASE_URL = 'http://github.com/api/' + API_VERSION + '/json/'

  USER_BASE_URL = BASE_URL + 'user/show/'
  REPO_BASE_URL = BASE_URL + 'repos/show/'
  COMMITS_BASE_URL = BASE_URL + 'commits/list/'
end

class DateTime
  def ical_timestamp
    strftime("%Y%m%dT%H%M%SZ")
  end
end

class String
  def remove_indent
    self =~ /\A([ \t]+)/ ? gsub(/\n#{$1}/, "\n").strip : self
  end
end
