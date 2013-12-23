{group, scale, contract, invert} = require '../ops'

exports.graph = {
  tag: "assumed"
  dag: [ {
    name: "Net"
    type: group
    children: [ "Gross", "~Ceded"]
    }, {
    name: "Gross"
    type: group
    opt: 30000000
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
    name: "Cat1"
    type: group
    opt: 1000000
    }, {
    name: "Cat2"
    type: group
    opt: 1000000
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
    name: "My:Cat1.Signed"
    type: scale
    opt:  0.06
    children: [ "Cat1"]
    }, {
    name: "My:Cat2.Signed"
    type: scale
    opt:  0.045
    children: [ "Cat2"]
    }, {
    name: "My:Program1"
    type: group
    children: [ "My:Cat1.Signed", "My:Cat2.Signed"]
    }, {
    name: "My:Assumed"
    type: group
    children: [ "My:Program1"]
    }
  ]
}
