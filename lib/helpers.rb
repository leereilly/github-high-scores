class BaseModel
  BASE_URL = 'https://api.github.com/'

  USER_BASE_URL = BASE_URL + 'users/'
  REPO_BASE_URL = BASE_URL + 'repos/'
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
