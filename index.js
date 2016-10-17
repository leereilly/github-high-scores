var express   = require('express'),
    validator = require('validator'),
    githubapi = require('github'),
    github    = new githubapi(),
    app       = express();

app.set('port', (process.env.PORT || 5000));

// public directory is used for assets
app.use(express.static(__dirname + '/public'));

// views directory is used for template files
app.set('views', __dirname + '/views');
app.set('view engine', 'ejs');

app.listen(app.get('port'), function() {
  console.log('Running on port', app.get('port'));
});


app.get('/', function(req, res) {
  // check whether the repo GET parameter is a valid URL
  var url = sanitize_url( req.query.repo )
  .then(function(url) {

    var isURL    = validator.isURL(url, {
          protocols: ['http','https'],
          allow_underscores: true
        });

    if(isURL) {
      // if it's a valid url, redirect to /user/repo
      var user = get_user_from_github_url(url),
          repo = get_repo_from_github_url(url);

      res.redirect(user + '/' + repo);
      return;

    } else if(url !== '') {
      // if the user entered an invalid url, render the home page with an error
      res.render('pages/notfound', { title: '404', error: 'Sorry, but this cat is in another castle!' });
      return;
    }

  }, function(err) {

    // if the user hasn't entered a url, just render the home page
    res.render('pages/index');
  });
});

app.get('/:user/:repo/?', function(req, res){
  // get the results
  var scores = get_high_scores(req.params.user, req.params.repo)
  .then(function(results) {

    // render the results
    res.render('pages/score', { scores: results, owner: req.params.user, repo: req.params.repo });

  }, function(err) {
    
    // handle error
    console.error(err);
    res.render('pages/notfound', { title: '404', error: 'Sorry, but this cat is in another castle!' });
  
  });
});

app.get('/:user/:repo/high_scores/?', function(req, res){
  // support for legacy links
  res.redirect('/' + req.params.user + '/' + req.params.repo);
});


// Credits, help, about pages
app.get('/credits/?', function(req, res){
  // render the credits page
  res.render('pages/credits');
});

app.get('/help/?', function(req, res){
  // render the help page
  res.render('pages/help');
});

app.get('/about/?', function(req, res){
  // render the about page
  res.render('pages/about');
});

// Error handers
app.use(function(req, res, next) {
  console.error('404');
  res.status(404).render('pages/notfound', { title: '404', error: 'Sorry, but this cat is in another castle!' });
});

app.use(function(err, req, res, next) {
  console.error(err.stack);
  res.status(500).render('pages/notfound', { title: 'Error 500', error: 'Sorry, something broke!' });
});


function get_user_from_github_url(sanitized_github_url) {
  return sanitized_github_url.split('/')[3];
};

function get_repo_from_github_url(sanitized_github_url) {
  return sanitized_github_url.split('/')[4];
};

function get_high_scores(user, repo) {
  return new Promise(function(resolve, reject) {

    github.repos.getContributors({
      owner: user,
      repo: repo,
      anon: true
    }, function(err, res) {

      // if there's an error, reject the promise
      if(err) {
        reject(err);
        return;
      } else if(typeof(res) == 'undefined') {
        reject('Repository not found');
        return;
      }

      // empty array to contain results
      var results = [];

      // score = contributions * 100
      // iterate through each user
      Promise.all( res.map( function(user) {

        // add current user to the results array
        return {
          username : user.login,
          score    : user.contributions * 100,
          avatar   : user.avatar_url
        };
        
      })).then( function(results) {

        // once the users have been processed, return the results
        resolve(results);
      });

    });

  });
};

function sanitize_url(unsanitized_url) {
  return new Promise(function(resolve, reject) {

    if( typeof(unsanitized_url) === 'undefined') {
      reject('No query');
      return;
    }

    var url = unsanitized_url.toLowerCase();

    // Check the start of the URL

    if (url.substring(0, 10) === 'github.com') {
      // Special rules for Github URLs starting with 'github.com'
      url = 'https://www.github.com' + url.substring(10);

    } else if (url.substring(0, 14) === 'www.github.com') {
      // Special rules for Github URLs starting with 'www.github.com'
      url = 'https://www.github.com' + url.substring(14);
    }

    // Check the end of the URL
    if (url.substring(url.length - 4) === '.git') {
      // Special rules for Github URLs ending in 'git'
      url = url.substring(0, url.length - 4);
    }

    url = url.replace("http://", "https://").replace("git@github.com:", "https://www.github.com/").replace("git://", "https://www.");

    // Check if someone just passes in user/repo e.g. leereilly/leereilly.net
    // Trim leading/trailing slash
    tokens = url.replace(/^\/|\/$/g, '').split('/');
    if (tokens.length === 2) {
      url = "https://www.github.com/" + tokens[0] + "/" + tokens[1];
    }

    resolve(url);
  });
};
