{group, scale, contract, invert} = require '../ops'

exports.graph = {
  tag: "sumnet2"
  dag: [ {
    name: "Cat1"
    type: contract
    opt: "10M xs 10M"
    children: ["PreCat"]
    }, {
    name: "PreCat"
    type: group
    children: ["A.PreCat", "C.PreCat"]
    }, {
    name: "A.PreCat"
    type: scale
    opt: 1.05
    children: [ "A net of B,D" ]
    }, {
    name: "C.PreCat"
    type: scale
    opt: 1.1
    children: ["C net of D"]
    }, {
    name: "C net of D"
    type: group
    children: [ "C", "~D" ]
    }, {
    name: "~D"
    type: invert
    children: [ "D" ]
    }, {
    name: "A net of B,D"
    type: group
    children: [ "A", "~B", "~D"]
    }, {
    name: "A"
    type: group
    opt: 1000000
    }, {
    name: "B"
    type: contract
    opt: "1M xs 1M p.r."
    children: [ "A" ]
    }, {
    name: "A,C"
    type: group
    children: [ "A", "C" ]
    }, {
    name: "C"
    type: group
    opt: 3000000
    }, {
    name: "D"
    type: contract
    opt: "10% share"
    children: [ "A,C" ]
    }, {
    name: "~B"
    type: invert
    children: [ "B" ]
    }
  ]
}
