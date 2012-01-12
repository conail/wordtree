//= require underscore
//= require backbone
//= require jquery
//= require d3.min
//= require d3.layout.min
//= require jquery_ujs
//= require terms
//= #require_tree .

CSSStyleDeclaration.prototype.getProperty = function(a) {
    return this.getAttribute(a);
};
CSSStyleDeclaration.prototype.setProperty = function(a,b) {
    return this.setAttribute(a,b);
}
CSSStyleDeclaration.prototype.removeProperty = function(a) {
    return this.removeAttribute(a);
}
