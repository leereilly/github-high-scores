var validator = require('validator'),
    https     = require('https');
                require('handlebars/runtime');

if (window.location.href.indexOf('?') > -1) {
  // Form submitted

  // Render the mini search bar
  var search = Handlebars.templates.search(),
      body   = document.getElementsByTagName("body")[0];

  body.innerHTML = search + "\n\n" + body.innerHTML;
  
  // Render the results
  render();

} else {
  // Index page
  var html = "<h2>High Scores</h2>\n" +
             "<p>Please enter a Github repository URL</p>\n";

  document.getElementsByClassName('wrapper')[0].innerHTML += html; 
             
  show_form();
}

// Process the search form
// Handles the mini search forms, as well as the one on the home page
document.getElementById('form').onsubmit = function(e) {
  // Handle form using process_form()
  e.preventDefault();
  process_form( document.getElementById('form').url.value );
  return false;
};

function show_form() {
  var form = "<form action='' id='form'>\n" +
             "\t<input type='text' size='24' name='url' />\n" +
             "\t<input type='submit' value='1 UP'/>\n" +
             "</form>\n";
  
  // Display the form
  document.getElementsByClassName('wrapper')[0].innerHTML += form;
}

function process_form(input) {
  // check whether the input is a valid URL
  var url = sanitize_url(input)
  .then(function(url) {

    var isURL    = validator.isURL(url, {
      protocols: ['http','https'],
      allow_underscores: true
    });

    if(isURL) {
      // if it's a valid url, redirect to ?user/repo
      var user = get_user_from_github_url(url),
          repo = get_repo_from_github_url(url);

      window.location = window.location.origin + '/github-high-scores/?' + user + '/' + repo;

    } else if(url !== '') {
      // if the user entered an invalid url, display error
      process_error();
    }

  }, function(err) {
    // couldn't sanitize url, display error
    process_error();
  });
}

function process_error() {
  var error = "<h2>404</h2>\n" +
              "<p>Sorry, but this cat is in another castle!</p>\n" +
              "<div class='align-center'>\n" +
              "\t<img src='/github-high-scores/img/octocat.png'>\n" +
              "</div>";

  document.getElementsByClassName('wrapper')[0].innerHTML = error;

  show_form();
}

function render() {
  var hash = window.location.search.replace('?','').split('/'),
      user = hash[0],
      repo = hash[1];

  get_high_scores(user,repo)
  .then(function(scores) {
    // get the handlebars template
    var template = Handlebars.templates.results;

    var html = "<h2><a href='/github-high-scores/?" + user + "'>" + user + "</a> &gt;&gt; <a href='/github-high-scores/?" + user + "/" + repo + "'>" + repo + "</a> &gt;&gt; <a href='/github-high-scores/?" + user + "/" + repo + "/high_scores'>High Scores</a></h2>\n" + 
               template({scores,user,repo});

    document.getElementsByClassName('wrapper')[0].innerHTML = html;

  });
}

function get_user_from_github_url(sanitized_github_url) {
  return sanitized_github_url.split('/')[3];
}

function get_repo_from_github_url(sanitized_github_url) {
  return sanitized_github_url.split('/')[4];
}

function get_high_scores(user, repo) {
  return new Promise(function(resolve, reject) {

    get_contributors(user,repo)
    .then(function(response) {

      // empty array to contain results
      var results = [];

      // score = contributions * 100
      // iterate through each user

      Promise.all( response.map( function(user) {
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

    })
    .catch(function(error) {
      // if there's an error, reject the promise
      if(typeof(error) === 'undefined') {
        reject('Repository not found');
        return;
      }
      reject(error);
      return;
    });

  });
}

function get_contributors(user, repo) {
  return new Promise(function(resolve, reject) {
    try {
      var options = {
        host: 'api.github.com',
        path: '/repos/' + user + '/' + repo + '/contributors'
      };

      var callback = function(response) {
        var str = '';

        //another chunk of data has been recieved, so append it to `str`
        response.on('data', function (chunk) {
          str += chunk;
        });

        //the whole response has been recieved, so we just print it out here
        response.on('end', function () {
          resolve(JSON.parse(str));
        });
      };

      https.request(options, callback).end();
    
    } catch(e) {
      reject('test:' + e);
    }

  });
}

function sanitize_url(unsanitized_url) {
  return new Promise(function(resolve, reject) {

    if( typeof(unsanitized_url) === 'undefined' || '' === unsanitized_url) {
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
}
