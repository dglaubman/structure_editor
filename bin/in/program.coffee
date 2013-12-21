{group, scale, contract, invert} = require '../ops'

exports.graph = {
  tag: "program"
  dag: [{
    name: "Program1"
    type: group
    children: ["Cat1", "Cat2"]
    }, {
    name: "Cat1"
    type: contract
    opt: "10M xs 10M"
    children: ["ABC, XYZ net of DEF, GHI"]
    }, {
    name: "Cat2"
    type: contract
    opt: "10M xs 20M"
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
    opt: 15000000
    }, {
    name: "XYZ"
    type: group
    opt: 12000000
    }, {
    name: "DEF"
    type: group
    opt: 3000000
    }, {
    name: "GHI"
    type: group
    opt: 2000000
    }
  ]
}
