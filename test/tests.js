var exec = require('child_process').exec;
var test = require('tape');

test('browserify runs successfully', function (t) {
  exec('browserify github-high-scores/index.js -o github-high-scores/js/app.js', (err, stdout, stderr) => {
    t.assert(!err, 'no errors')
    t.end()
  })
});

test('handlebars precompile successfully', function (t) {
  exec('handlebars github-high-scores/partials -f github-high-scores/js/handlebars.js -k each -k if -k unless', (err, stdout, stderr) => {
    t.assert(!err, 'no errors')
    t.end()
  })
});
