{group, scale, contract, invert} = require '../ops'

exports.graph = {
  tag: "netpos"
  dag: [ {
    name: "ABC, XYZ net of DEF, GHI"
    type: group
    children: [ "ABC", "XYZ", "~DEF", "~GHI"]
    }, {
    name: "ABC"
    type: group
    opt: 5000000
    }, {
    name: "XYZ"
    type: group
    opt: 3000000
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
