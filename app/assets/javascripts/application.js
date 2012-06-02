//= require jquery
//= require jquery_ujs
//#= require underscore
//#= require backbone
//= require d3.v2.min
//= require twitter/bootstrap
//= require trees

CSSStyleDeclaration.prototype.getProperty = function(a) {
    return this.getAttribute(a);
};
CSSStyleDeclaration.prototype.setProperty = function(a,b) {
    return this.setAttribute(a,b);
}
CSSStyleDeclaration.prototype.removeProperty = function(a) {
    return this.removeAttribute(a);
}
