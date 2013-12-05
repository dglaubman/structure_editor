_ = require 'underscore'
fs = require 'fs'
path = require 'path'

{log, fatal, error, trace, logger} = require './log'
{argv} = require 'optimist'
{group, scale, contract, invert} = require './ops'

logger argv

encode = (arg) -> encodeURIComponent arg
decode = (arg) -> decodeURIComponent arg

graphDir = argv.graphDir or "."
dotDir = argv.dotDir or "."
inputDir = argv.inputDir or "./in"

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
      "#{(opt * 100).toFixed 1}%"   # scale factor
    when invert
      '-'
    when contract
      opt                           # contract description

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
      switch type
        when scale
          cmds.push "start scale #{encode name} opt"   # opt is scale factor
        when contract
          cmds.push "start contract #{encode name} #{encode name}"   # cdl filename is same as contract name
        else
          cmds.push "start #{type} #{encode name}"

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

try
  files = fs.readdirSync inputDir
  _.each files, (file) ->
    pathname = "#{inputDir}/#{file}"
    stats = fs.statSync pathname
    return unless stats.isFile() and pathname.substr( -7 ) is '.coffee'
    {graph} = require pathname
    convert graph
catch e
  error e
