{group, scale, contract, invert, comment} = require '../ops'

exports.graph = {
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
    opt:  0.3
    children: [ "Cat1"]
    }, {
    name: "Cat2.Placed"
    type: scale
    opt:  0.45
    children: [ "Cat2"]
    }, {
    name: "Cat1"
    type: contract
    opt:  "10M xs 10M"
    children: [ "Gross"]
    }, {
    name: "Cat2"
    type: contract
    opt: "10M xs 20M"
    children: [ "Gross"]
    }, {
    name: "Gross"
    type: group
    opt: 30000000
    }
  ]
}
