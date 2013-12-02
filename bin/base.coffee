_ = require("underscore")
fs = require("fs")
{fatal, error, trace, logger} = require './log'
{argv} = require 'optimist'

group = "group"
scale = "scale"
contract = "contract"
invert = "invert"

encode = (arg) -> encodeURIComponent arg
decode = (arg) -> decodeURIComponent arg

graphDir = argv.graphDir or "."
dotDir = argv.dotDir or "."

logger argv

out = (path, data) ->
  fs.writeFile( path, data, (err) -> if err then throw err )

outputGraph = (path, data) ->
  out "#{graphDir}/#{path}.json", data

outputDot = (path, data) ->
  out "#{dotDir}/#{path}.dot", data.join '\n'

labelEdge = (type, opt) ->
  switch type
    when group
      '+'
    when scale
      "#{(opt.val * 100).toFixed 1}%"
    when invert
      '-'
    when contract
      opt.desc

convert = ( g ) ->
  {tag, dag} = g

  # number the nodes
  ix = {}
  i = 0
  _.each dag, (node) ->
    ix[node.name] = i++
  nodes = []
  edges = []
  cmds = []
  #trace ix

  try
    _.each dag, (node) ->
      {name, type, children, opt} = node
      # print start engine cmd
      cmds.push "start #{type} #{encode name} #{opt?.val or ''}"
      # print start trigger cmd
      if children
        if not Array.isArray children then throw "bad node '#{node.name}' -- children should be an array"
        cmds.push "start trigger #{encode name} #{_.map(children, encode).join(',')}"
      # create graph node
      if name[0] isnt '~' # Dont show invert nodes, just label them as part of their group(s)
        nodes.push { id: ix[name], value: { label: name } }
        _.each children, (child) ->
          #trace child
          # create links for node
          if child[0] is '~'
            edge = {
              u: ix[name]
              v: ix[ child.substring 1 ]
              value: { type: invert, label: labelEdge invert, opt }
            }
          else
            edge = {
              u: ix[name]
              v: ix[child]
              value: { type: type, label: labelEdge type, opt }
            }
          edges.push edge
          trace edge
  catch e
   fatal "error traversing graph '#{tag}': #{e}"
  trace edges
  outputGraph tag, JSON.stringify {
    nodes
    edges
  }, undefined, 2

  outputDot tag, cmds

imported_wx = {
  tag: "imported_wx"
  dag : [ {
    name: "Acme:Net"
    type: group
    children: [ "Acme:Gross", "~Acme:Ceded" ]
    }, {
    name: "Acme:Gross"
    type: group
    children: [ "Acme:PortA" ]
    }, {
    name: "Acme:PortA"
    type: group
    }, {
    name: "~Acme:Ceded"
    type: invert
    children: [ "Acme:Ceded" ]
    }, {
    name: "Acme:Ceded"
    type: group
    children: [ "Acme:Fac", "Acme:PerRisk", "Acme:Cat" ]
    }, {
    name: "Acme:Cat"
    type: group
    }, {
    name: "Acme:PerRisk"
    type: group
    children: [ "Acme:WX1.Placed" ]
    }, {
    name: "Acme:Fac"
    type: group
    }, {
    name: "Acme:WX1.Placed"
    type: scale
    children: [ "Market:WX1" ]
    opt: { val: 0.4 }
    }, {
    name: "Market:WX1"
    type: contract
    children: [ "Acme:PortA" ]
    opt: { val: "Market:WX1", desc: "10M xs 10M" }
    }, {
    name: "Our:Net"
    type: group
    children: [ "Our:Assumed", "~Our:Ceded" ]
    }, {
    name: "~Our:Ceded"
    type: invert
    children: [ "Our:Ceded" ]
    }, {
    name: "Our:Assumed"
    type: group
    children: [ "Our:WX1.Signed" ]
    }, {
    name: "Our:Ceded"
    type: group
    children: [ "Our:WX1.Ceded" ]
    }, {
    name: "Our:WX1.Ceded"
    type: scale
    children: [ "Our:WX1.Signed" ]
    opt: { val: 0.5 }
    }, {
    name: "Our:WX1.Signed"
    type: scale
    children: [ "Market:WX1" ]
    opt: { val: 0.07 }
    }
  ]
}


imported_wx_small = {
  tag: "imported_wx_small"
  dag : [ {
    name: "Acme:Net"
    type: group
    children: [ "Acme:Gross", "~Acme:Ceded" ]
    }, {
    name: "Acme:Gross"
    type: group
    children: [ "Acme:PortA" ]
    }, {
    name: "Acme:PortA"
    type: group
    }, {
    name: "~Acme:Ceded"
    type: invert
    children: [ "Acme:Ceded" ]
    }, {
    name: "Acme:Ceded"
    type: group
    children: [ "Acme:PerRisk" ]
    }, {
    name: "Acme:Cat"
    type: group
    }, {
    name: "Acme:PerRisk"
    type: group
    children: [ "Acme:WX1.Placed" ]
    }, {
    name: "Acme:Fac"
    type: group
    }, {
    name: "Acme:WX1.Placed"
    type: scale
    children: [ "Market:WX1" ]
    opt: { val: 0.4 }
    }, {
    name: "Market:WX1"
    type: contract
    children: [ "Acme:PortA" ]
    opt: {val: "Market:WX1", desc: "10M xs 10M" }
    }, {
    name: "Our:Net"
    type: group
    children: [ "Our:Assumed", "~Our:Ceded" ]
    }, {
    name: "~Our:Ceded"
    type: invert
    children: [ "Our:Ceded" ]
    }, {
    name: "Our:Assumed"
    type: group
    children: [ "Our:WX1.Signed" ]
    }, {
    name: "Our:Ceded"
    type: group
    children: [ "Our:WX1.Ceded" ]
    }, {
    name: "Our:WX1.Ceded"
    type: scale
    children: [ "Our:WX1.Signed" ]
    opt: { val: 0.5 }
    }, {
    name: "Our:WX1.Signed"
    type: scale
    children: [ "Market:WX1" ]
    opt: { val: 0.07 }
    }
  ]
}

netpos = {
  tag: "netpos"
  dag: [ {
    name: "ABC, XYZ net of DEF, GHI"
    type: group
    children: [ "ABC", "XYZ", "~DEF", "~GHI"]
    }, {
    name: "ABC"
    type: group
    }, {
    name: "XYZ"
    type: group
    }, {
    name: "~DEF"
    type: invert
    children: ["DEF"]
    }, {
    name: "~GHI"
    type: invert
    children: ["GHI"]
    }, {
    name: "DEF"
    type: group
    }, {
    name: "GHI"
    type: group
    }
  ]
}

reins = {
  tag: "reins"
  dag: [ {
    name: "Ceded"
    type: group
    children: [ "Fac", "PerRisk", "Cat"]
    }, {
    name: "Fac"
    type: group
    children: ["Fac1"]
    }, {
    name: "PerRisk"
    type: group
    children: ["SST", "PRT"]
    }, {
    name: "~Fac"
    type: invert
    children: ["Fac"]
    }, {
    name: "Gross net of SST"
    type: group
    children: ["Gross", "~SST"]
    }, {
    name: "~SST"
    type: invert
    children: ["SST"]
    }, {
    name: "PRT"
    type: contract
    opt: { val: "PRT", desc: "20M xs 15M per risk" }
    children: ["Gross net of SST"]
    }, {
    name: "Fac1"
    type: contract
    opt: { val: "Fac1", desc: "1M xs 1M {IBM Acct)" }
    children: ["Gross"]
    }, {
    name: "SST"
    type: contract
    opt: { val: "SST", desc: "4 lines @ 250K " }
    children: ["Gross net of Fac"]
    }, {
    name: "Gross net of Fac"
    type: group
    children: ["Gross", "~Fac"]
    }, {
    name: "Cat"
    type: group
    children: [ "Cat1.Placed", "Cat2.Placed"]
    }, {
    name: "Cat1.Placed"
    type: scale
    opt: { val: 0.3 }
    children: [ "Cat1"]
    }, {
    name: "Cat2.Placed"
    type: scale
    opt: { val: 0.45 }
    children: [ "Cat2"]
    }, {
    name: "Cat1"
    type: contract
    opt: { val: "Cat1", desc: "20M xs 5M Wind" }
    children: [ "Gross"]
    }, {
    name: "Cat2"
    type: contract
    opt: { val: "Cat2", desc: "10M xs 10M" }
    children: [ "Gross"]
    }, {
    name: "Gross"
    type: group
    }
  ]
}

travelers = {
  tag: "travelers"
  dag: [ {
    name: "Fac"
    type: group
    children: ["F1", "F2", "F3"]
    }, {
    name: "PerRisk"
    type: group
    children: ["PPR_Layer1", "Fac", "SST"]
    }, {
    name: "Book"
    type: group
    }, {
    name: "F1"
    type: contract
    opt: { val: "F1", desc: "4M xs 4M" }
    children: ["Book"]
    }, {
    name: "F2"
    type: contract
    opt: { val: "F2", desc: "4M xs 1M" }
    children: ["Book"]
    }, {
    name: "F3"
    type: contract
    opt: { val: "F3", desc: "10M xs 15M" }
    children: ["Book"]
    }, {
    name: "HighFac"
    type: group
    children: ["F3"]
    }, {
    name: "PPR_Layer1"
    type: contract
    opt: { val: "PPR_Layer1", desc: "20 xs 15 per risk" }
    children: ["Book net of SST, HighFac"]
    }, {
    name: "SST"
    type: contract
    opt: { val: "SST", desc: "50% w/ 50M occ" }
    children: ["Book net of Fac"]
    }, {
    name: "Book net of Fac"
    type: group
    children: ["Book", "~Fac"]
    }, {
    name: "~Fac"
    type: invert
    children: ["Fac"]
    }, {
    name: "~SST"
    type: invert
    children: [ "SST" ]
    }, {
    name: "~HighFac"
    type: invert
    children: [ "HighFac" ]
    }, {
    name: "Book net of SST, HighFac"
    type: group
    children: ["Book", "~SST", "~HighFac"]
    }
  ]
}

placed = {
  tag: "placed"
  dag: [ {
    name: "Net"
    type: group
    children: [ "Gross", "~Ceded"]
    }, {
    name: "~Ceded"
    type: invert
    children: [ "Ceded"]
    }, {
    name: "Ceded"
    type: group
    children: [ "Fac", "PerRisk", "Cat"]
    }, {
    name: "Fac"
    type: group
    }, {
    name: "PerRisk"
    type: group
    }, {
    name: "Cat"
    type: group
    children: [ "Cat1.Placed", "Cat2.Placed"]
    }, {
    name: "Cat1.Placed"
    type: scale
    opt: { val: 0.3 }
    children: [ "Cat1"]
    }, {
    name: "Cat2.Placed"
    type: scale
    opt: { val: 0.45 }
    children: [ "Cat2"]
    }, {
    name: "Cat1"
    type: contract
    opt: { val: "Cat1", desc: "20M xs 5M" }
    children: [ "Gross"]
    }, {
    name: "Cat2"
    type: contract
    opt: { val: "Cat2", desc: "10M xs 10M" }
    children: [ "Gross"]
    }, {
    name: "Gross"
    type: group
    }
  ]
}

standard = {
  tag: "standard"
  dag: [ {
    name: "Net"
    type: group
    children: [ "Gross", "~Ceded"]
    }, {
    name: "~Ceded"
    type: invert
    children: [ "Ceded"]
    }, {
    name: "Ceded"
    type: group
    children: [ "Fac", "PerRisk", "Cat"]
    }, {
    name: "Gross"
    type: group
    children: [ "Direct", "Assumed"]
    }, {
    name: "Direct"
    type: group
    }, {
    name: "Assumed"
    type: group
    }, {
    name: "Fac"
    type: group
    }, {
    name: "PerRisk"
    type: group
    }, {
    name: "Cat"
    type: group

    }
  ]
}

graphs = [ imported_wx, imported_wx_small, netpos, placed, reins, travelers, standard ]
convert graph for graph in graphs

