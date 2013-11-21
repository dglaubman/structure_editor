_ = require("underscore")
fs = require("fs")
{trace, logger} = require './log'
{argv} = require 'optimist'

group = "group"
scale = "scale"
contract = "contract"
invert = "invert"

prefix = argv.path or "."
logger argv
rak = argv.rak or 1

out = (path, data) ->
  fs.writeFile( path, data, (err) -> if err then throw err )

outputGraph = (path, data) ->
  out "#{prefix }/#{path}.json", data

outputDot = (path, data) ->
  out "#{prefix }/#{path}.dot", data.join '\n'

labelEdge = (type, opt) ->
  switch type
    when group
      '+'
    when scale
      "#{(opt * 100).toFixed 1}%"
    when invert
      '-'
    when contract
      opt


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
      cmds.push "start #{type} #{name} #{opt or ''}"
      # print start trigger cmd
      if children
        cmds.push "start trigger #{name} #{children} #{rak}"
      # create graph node
      nodes.push { id: ix[name], value: { label: name } }
      _.each children, (child) ->
        #trace child
        # create links for node
        edge = {
          u: ix[name]
          v: ix[child]
          value: { type: type, label: labelEdge type, opt }
        }
        edges.push edge
        trace edge
  catch e
    trace edges
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
    opt: 0.4
    }, {
    name: "Market:WX1"
    type: contract
    children: [ "Acme:PortA" ]
    opt: "10x10"
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
    opt: 0.5
    }, {
    name: "Our:WX1.Signed"
    type: scale
    children: [ "Market:WX1" ]
    opt: 0.07
    }
  ]
}

graphs = [ imported_wx ]
convert graph for graph in graphs

