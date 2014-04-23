![](http://i.imgur.com/aWmdUAK.png)

Github High Scores is a fun way to rank Github repository contributors in a 8-bit, 80's-tastic viewing environment.

## Installation

This is a Ruby Sinatra app, so you'll need to know some Ruby-Fu to get it working locally.

    git clone git://github.com/leereilly/github-high-scores.git
    bundle install
    ruby app.rb

## Contribute

Fork + pull.

## Credits
* Running with Ruby, Sinatra, Heroku
* Powered by the [Github API](http://develop.github.com/)
* Written by Lee Reilly
* Octocat logo used with permission
* Inspiration from http://twistedmatrix.com/highscores/

## Kudos/Thanks

* [Jonas Obrist a.k.a. ojii](http://github-high-scores.heroku.com/ojii) for pointing out than anonymous users were being ignored
* [Chris Lee a.k.a. cleercode](http://github-high-scores.heroku.com/cleercode) for corrocting my speeling
* [Jesse Andrews a.k.a. anotherjesse](http://github-high-scores.heroku.com/anotherjesse) for some UI cleanup
* [Gerrit Riessen a.k.a gorenje](https://github.com/gorenje) - for some refactoring

## Known Issues / Bugs / Limitations
* The GitHub API only allows 60 requests per minute per IP address.
* The site looks like some sort of 80s-tastic arcade theme.

![Bugs](http://i.imgur.com/K8vsw.gif "Bugs")
