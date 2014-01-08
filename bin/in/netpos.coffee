{group, scale, contract, invert, comment} = require '../ops'

exports.graph = {
  tag: "netpos"
  dag: [ {
    name: "Our:ABC, XYZ net of DEF, GHI"
    type: group
    children: [ "Our:ABC", "Our:XYZ", "~Our:DEF", "~Our:GHI"]
    }, {
    name: "Our:ABC"
    type: group
    opt: 5000000
    }, {
    name: "Our:XYZ"
    type: group
    opt: 3000000
    }, {
    name: "~Our:DEF"
    type: invert
    children: ["Our:DEF"]
    }, {
    name: "~Our:GHI"
    type: invert
    children: ["Our:GHI"]
    }, {
    name: "Our:DEF"
    type: group
    opt: 120000
    }, {
    name: "Our:GHI"
    type: group
    opt: 250000
    }
  ]
}
