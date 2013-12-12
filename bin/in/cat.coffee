{group, scale, contract, invert} = require '../ops'

exports.graph = {
  tag: "cat"
  dag: [ {
    name: "Cat1"
    type: contract
    opt: "10M xs 10M"
    children: ["ABC, XYZ net of DEF, GHI"]
    }, {
    name: "ABC, XYZ net of DEF, GHI"
    type: group
    children: ["ABC", "XYZ", "~DEF", "~GHI"]
    }, {
    name: "~DEF"
    type: invert
    children: [ "DEF" ]
    }, {
    name: "~GHI"
    type: invert
    children: [ "GHI" ]
    }, {
    name: "ABC"
    type: group
    }, {
    name: "XYZ"
    type: group
    }, {
    name: "DEF"
    type: group
    }, {
    name: "GHI"
    type: group
    }
  ]
}
