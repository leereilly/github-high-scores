# OVERVIEW

Github High Scores is a fun way to rank Github repository contributors in a 8-bit, 80's-tastic viewing environment.

## Installation

    git clone git://github.com/leereilly/github-high-scores.git
    rvm install ruby-1.8.7-p334 ## didn't have correct version
    cd github-high-scores
    gem install bundler
    bundle
    db_use=sqlite_default ruby app.rb

## Configuration

You can either use mysql, sqlite or sqlite with default setting

For mysql:

You'll need to set environment variables on your box. Locally, you can
set them in your .bash_profile...

    export db_use=mysql
    export db_user=some_username
    export db_pass=some_password
    export db_host=some_host
    export db_data=some_database

On Heroku, you can do something like this...

    heroku config:add db_user=XXX db_pass=XXX db_host=XXX db_data=XXX db_use=mysql

For sqlite:

    export db_use=sqlite
    export db_path=/some/absolute/path/to/my.db

For sqlite + default:

    export db_use=sqlite_default

This then creates a my.db database file in db/

See app.rb for details.

## Contribute

Fork + pull.

## Credits
* Running with Ruby, Sinatra, Heroku
* Powered by the Github API
* Written by Lee Reilly
* Octocat logo used with permission
* Inspiration from http://twistedmatrix.com/highscores/

## Known Issues / Bugs / Limitations
* The GitHub API only allows 60 requests per minute per IP address.
* The site looks like some sort of 80s-tastic arcade theme.

![Bugs](http://i.imgur.com/K8vsw.gif "Bugs")
