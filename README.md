# OVERVIEW

Github High Scores is a fun way to rank Github repository contributors in a 8-bit, 80's-tastic viewing environment.

## INSTALLATION

    git clone git://github.com/leereilly/github-high-scores.git
    cd github-high-scores
    ruby app.rb

## CONFIGURATION

You'll need to set environment variables on your box. Locally, you can set them in your .bash_profile...

    export db_user=some_username
    export db_pass=some_password
    export db_host=some_host
    export db_data=some_database

On Heroku, you can do something like this...

    heroku config:add db_user=XXX db_pass=XXX db_host=XXX db_data=XXX

## CONTRIBUTE

Fork + pull.

## CREDITS / KUDOS
* Running with Ruby, Sinatra, Heroku
* Powered by the Github API
* Written by Lee Reilly
* Octocat logo used with permission

# Known Issues / Bugs / Limitations
* The GitHub API only allows 60 requests per minute per IP address.
* The site looks like some sort of 80s-tastic arcade theme.

![Bugs](http://i.imgur.com/K8vsw.gif "Bugs")