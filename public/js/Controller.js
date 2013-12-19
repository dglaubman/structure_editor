// Generated by CoffeeScript 1.6.3
(function() {
  var root;

  root = typeof exports !== "undefined" && exports !== null ? exports : window;

  root.Controller = (function() {
    var format, tracks;

    function Controller(log) {
      this.log = log;
    }

    Controller.prototype.stat = function(track, position, loss) {
      var _ref, _ref1;
      this.log.write("" + position + ": " + loss);
      return (_ref = tracks[track]) != null ? (_ref1 = _ref[position]) != null ? _ref1.text(format(loss)) : void 0 : void 0;
    };

    Controller.prototype.ready = function(route, track) {
      var nodes, positions;
      this.log.write("" + route + " on " + track);
      nodes = graph().nodes;
      positions = tracks[track] || (tracks[track] = {});
      return d3.selectAll(".stat text").each(function(d, i) {
        var x;
        x = d3.select(this);
        x.text("");
        return positions[encode(nodes[i].value.label)] = x;
      });
    };

    Controller.prototype.stopped = function(type, name) {
      return this.log.write("recd stopped signal for " + type + " " + name);
    };

    Controller.prototype.dataReady = function(at, text) {};

    Controller.prototype.stopServer = function(event) {
      return alert("please set action for Controller.stopServer");
    };

    tracks = {};

    format = function(number) {
      switch (false) {
        case !(number >= 1000000000):
          return "" + (number / 1000000000) + "B";
        case !(number >= 1000000):
          return "" + (number / 1000000) + "M";
        case !(number >= 1000):
          return "" + (number / 1000) + "K";
        default:
          return number;
      }
    };

    return Controller;

  })();

}).call(this);
