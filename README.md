# OVERVIEW

Github High Scores is a fun way to rank Github repository contributors in a 8-bit, 80's-tastic viewing environment.

## Installation

    git clone git://github.com/leereilly/github-high-scores.git
    cd github-high-scores
    ruby app.rb

## Configuration

You'll need to set environment variables on your box. Locally, you can set them in your .bash_profile...

    export db_user=some_username
    export db_pass=some_password
    export db_host=some_host
    export db_data=some_database

On Heroku, you can do something like this...

    heroku config:add db_user=XXX db_pass=XXX db_host=XXX db_data=XXX

## Contribute

Fork + pull.

## Credits
* Running with Ruby, Sinatra, Heroku
* Powered by the Github API
* Written by Lee Reilly
* Octocat logo used with permission
* Inspiration from http://twistedmatrix.com/highscores/

# Kudos/Thanks

* [Jonas Obrist a.k.a. ojii](http://github-high-scores.heroku.com/ojii) for pointing out than anonymous users were being ignored
* [Chris Lee a.k.a. cleercode](http://github-high-scores.heroku.com/cleercode) for corrocting my speeling
* [Jesse Andrews a.k.a. anotherjesse](http://github-high-scores.heroku.com/anotherjesse) for some UI cleanup

## Known Issues / Bugs / Limitations
* The GitHub API only allows 60 requests per minute per IP address.
* The site looks like some sort of 80s-tastic arcade theme.

![Bugs](http://i.imgur.com/K8vsw.gif "Bugs")