_ = require 'underscore'
{group, scale, contract, invert, filter, comment} = require './ops'
{parser} = require './pgl-ast'

encode = (arg) -> encodeURIComponent arg
decode = (arg) -> decodeURIComponent arg

base = (fqn) ->
  [ns, barename] = fqn.split ':'
  barename or ns

labelEdge = (type, opt) ->
  switch type
    when group
      '+'
    when scale
      "#{(opt * 100).toFixed 1}%"   # scale factor
    when invert
      '-'
    when contract
      opt[1]                        # contract description
    when filter
      opt                           # filter description

module.exports = convert = ( text ) ->

  dag = parser.parse text

  # number the nodes
  ix = {}
  children = {}
  i = 1
  _.each dag, (node) ->
    ix[ node[0] ] or= i++
    _.each node[2], (childNode) ->
      children[childNode] = childNode

  _.each children, (child) ->
    if not ix[child]
      ix[child] = i++
      dag.push [child, group, [], 0]

  nodes = []
  edges = []
  cmds = []
  leaves = {}
  # trace ix

  try
    _.each dag, (node) ->
      # trace node
      [name, type, children, opt] = node
      # print start engine cmd
      switch type
        when scale
          cmds.push "start scale #{encode name} #{opt}"   # opt is scale factor
        when contract
          cmds.push "start inline #{encode name} #{encode opt[0]}"   # send cdl inline
#          cmds.push "start contract #{encode name} #{encode name}"   # cdl filename is same as contract name
        when filter
          cmds.push "start filter #{encode name} #{encode name}"   # filter filename is same as filter name
        when invert
          cmds.push "start #{type} #{encode name}"
        when group
          cmds.push "start #{type} #{encode name}"

      # print start trigger cmd
      if not Array.isArray children then throw "bad node '#{node.name}' -- children should be an array"
      if not  _.isEmpty children
        cmds.push "start trigger #{encode name} #{_.map(children, encode).join(',')}"
      else if type is group # only groups can be leaves. 'opt' holds their initial value.
        leaves[name] = opt or 0
        cmds.push "start trigger #{encode name} Start_#{encode name}"
      # create graph node
      if name[0] isnt '~' # Dont show invert nodes, just label them as part of their group(s)
        nodes.push { id: ix[name], value: { key: name, label: base name } }
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
          #trace edge
  catch e
    console.log "error traversing graph: #{e}"
    return null

  return {
    dag: { nodes, edges, initial: leaves }
    cmds
  }
