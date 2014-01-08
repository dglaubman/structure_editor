{group, scale, contract, invert, comment} = require '../ops'

exports.graph = {
  tag: "program"
  dag: [{
    name: "Market:Program1"
    type: group
    children: ["Market:Cat1", "Market:Cat2"]
    }, {
    name: "Market:Cat1"
    type: contract
    opt: "10M xs 10M"
    children: ["ABC, XYZ net of DEF, GHI"]
    }, {
    name: "Market:Cat2"
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
    }, {
    name: "Market:Offered to market"
    type: comment
    }
  ]
}
