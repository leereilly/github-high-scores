(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['user'] = template({"1":function(container,depth0,helpers,partials,data) {
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
    var stack1;

  return "<table>\r\n  <tr>\r\n    <th>Score</th>\r\n    <th>Avatar</th>\r\n    <th>User</th>\r\n  </tr>\r\n\r\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : {},(depth0 != null ? depth0.scores : depth0),{"name":"each","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data})) != null ? stack1 : "")
    + "  <tr><td>test</td><td>test</td><td>test</td></tr>\r\n\r\n</table>\r\n";
},"useData":true});
})();