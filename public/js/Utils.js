// Generated by CoffeeScript 1.6.3
(function() {
  var root;

  root = typeof exports !== "undefined" && exports !== null ? exports : window;

  root.every = function(ms, func) {
    if (ms < Infinity) {
      func();
      return setInterval(func, ms);
    }
  };

  root.encode = function(str) {
    return encodeURIComponent(str);
  };

}).call(this);
