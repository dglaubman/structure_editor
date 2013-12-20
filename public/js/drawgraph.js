// Generated by CoffeeScript 1.6.3
(function() {
  var graph, nodeSep, rankDir, render, root, update, _graph;

  root = typeof exports !== "undefined" && exports !== null ? exports : window;

  nodeSep = 60;

  rankDir = "TB";

  _graph = void 0;

  root.graph = graph = function(adjacencies) {
    if (arguments.length > 0) {
      return _graph = adjacencies;
    } else {
      return _graph;
    }
  };

  root.update = update = function(input) {
    var path;
    path = "data/" + input + ".json";
    return d3.json(path, render);
  };

  root.render = render = function(adjacencies) {
    var edges, height, layout, margin, nodes, oldDrawEdgeLabel, oldDrawNode, renderer, svg, width;
    graph(adjacencies);
    margin = {
      top: 20,
      right: 20,
      bottom: 20,
      left: 20
    };
    width = adjacencies.width || 920;
    height = adjacencies.height || 900;
    d3.selectAll("svg.chart").remove();
    svg = d3.select("#chart").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).style("margin-left", -margin.left + "px").classed("chart", true).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    nodes = adjacencies.nodes;
    edges = adjacencies.edges;
    renderer = new dagreD3.Renderer();
    oldDrawNode = renderer.drawNode();
    oldDrawEdgeLabel = renderer.drawEdgeLabel();
    renderer.drawNode(function(graph, u, svg) {
      oldDrawNode(graph, u, svg);
      return svg.attr("id", "node-" + u);
    });
    renderer.drawEdgeLabel(function(graph, e, svg) {
      var val;
      oldDrawEdgeLabel(graph, e, svg);
      val = graph._edges[e].value;
      svg.attr("class", val.type);
      if (val.type === "choose") {
        return svg.attr("class", val.tag);
      }
    });
    layout = dagreD3.layout().nodeSep(nodeSep).rankDir(rankDir);
    renderer.layout(layout).run(dagreD3.json.decode(nodes, edges), d3.select("#chart svg g"));
    return d3.selectAll("svg .node").append('g').classed('stat', true).attr("transform", "translate(0, 40)").append('text').text(function(d) {
      return d;
    });
  };

  root.nodeSep = function(n) {
    nodeSep = n;
    return render(graph());
  };

  rankDir = "TB";

  root.toggle = function() {
    if (rankDir === "TB") {
      rankDir = "LR";
    } else {
      rankDir = "TB";
    }
    return render(graph());
  };

}).call(this);
