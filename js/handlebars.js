(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['results'] = template({"1":function(container,depth0,helpers,partials,data) {
    var alias1=container.lambda, alias2=container.escapeExpression;

  return "    <tr id=\"person-"
    + alias2(alias1((depth0 != null ? depth0.username : depth0), depth0))
    + "\">\r\n      <div itemscope itemtype=\"http://data-vocabulary.org/Person\">\r\n        <td>"
    + alias2(alias1((depth0 != null ? depth0.score : depth0), depth0))
    + "</td>\r\n        <td>\r\n          <img itemprop=\"photo\" src=\""
    + alias2(alias1((depth0 != null ? depth0.avatar : depth0), depth0))
    + "\" width=\"50\" height=\"50\">\r\n        </td>\r\n        <td>\r\n          <span itemprop=\"nickname\"><a href=\"/"
    + alias2(alias1((depth0 != null ? depth0.username : depth0), depth0))
    + "\">"
    + alias2(alias1((depth0 != null ? depth0.username : depth0), depth0))
    + "</a></span>\r\n        </td>\r\n        <td>\r\n          <a class=\"permalink\" href=\"#person-"
    + alias2(alias1((depth0 != null ? depth0.username : depth0), depth0))
    + "\"></a>\r\n        </td>\r\n    </tr>\r\n";
},"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, alias1=depth0 != null ? depth0 : {}, alias2=helpers.helperMissing, alias3="function", alias4=container.escapeExpression;

  return "<table>\r\n  <tr>\r\n    <th>Score</th>\r\n    <th>Avatar</th>\r\n    <th>User</th>\r\n  </tr>\r\n\r\n"
    + ((stack1 = helpers.each.call(alias1,(depth0 != null ? depth0.scores : depth0),{"name":"each","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "\r\n</table>\r\n\r\n<p class=\"small\">Permalink: <a href=\"http://gitscore.heroku.com/#"
    + alias4(((helper = (helper = helpers.user || (depth0 != null ? depth0.user : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"user","hash":{},"data":data}) : helper)))
    + "/"
    + alias4(((helper = (helper = helpers.repo || (depth0 != null ? depth0.repo : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"repo","hash":{},"data":data}) : helper)))
    + "\">http://gitscore.heroku.com/#"
    + alias4(((helper = (helper = helpers.user || (depth0 != null ? depth0.user : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"user","hash":{},"data":data}) : helper)))
    + "/"
    + alias4(((helper = (helper = helpers.repo || (depth0 != null ? depth0.repo : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"repo","hash":{},"data":data}) : helper)))
    + "</a></p>\r\n\r\n<p class=\"small\"><a href=\"http://twitter.com/share?text=Check+out+the+high+score+chart+for+my+"
    + alias4(((helper = (helper = helpers.repo || (depth0 != null ? depth0.repo : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"repo","hash":{},"data":data}) : helper)))
    + "+repo+on+GitHub%21&url=http%3A%2F%2Fgitscore.herokuapp.com%2F%23"
    + alias4(((helper = (helper = helpers.user || (depth0 != null ? depth0.user : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"user","hash":{},"data":data}) : helper)))
    + "/"
    + alias4(((helper = (helper = helpers.repo || (depth0 != null ? depth0.repo : depth0)) != null ? helper : alias2),(typeof helper === alias3 ? helper.call(alias1,{"name":"repo","hash":{},"data":data}) : helper)))
    + "\" target=\"_lbank\">Tweet this!</a></p>\r\n";
},"useData":true});
templates['search'] = template({"compiler":[7,">= 4.0.0"],"main":function(container,depth0,helpers,partials,data) {
    return "<div class=\"fl-right\">\r\n  <form action='' id='form'>\r\n    <input type='text' size='24' name='url' class='small' />\r\n    <input type='submit' value='1 UP' class='small' />\r\n  </form>\r\n</div>\r\n";
},"useData":true});
})();