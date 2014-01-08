{group, scale, contract, invert, comment} = require '../ops'

exports.graph = {
  tag: "assumed"
  dag: [ {
    name: "AIG:Net"
    type: group
    children: [ "AIG:Gross", "~AIG:Ceded"]
    }, {
    name: "AIG:Gross"
    type: group
    opt: 30000000
    }, {
    name: "~AIG:Ceded"
    type: invert
    children: [ "AIG:Ceded"]
    }, {
    name: "AIG:Ceded"
    type: group
    children: [ "AIG:Fac", "AIG:PerRisk", "AIG:Cat"]
    }, {
    name: "AIG:Fac"
    type: group
    }, {
    name: "AIG:PerRisk"
    type: group
    }, {
    name: "AIG:Cat"
    type: group
    children: [ "AIG:Cat1.Placed", "AIG:Cat2.Placed"]
    }, {
    name: "AIG:Cat1"
    type: group
    opt: 1000000
    }, {
    name: "AIG:Cat2"
    type: group
    opt: 1000000
    }, {
    name: "AIG:Cat1.Placed"
    type: scale
    opt:  0.3
    children: [ "AIG:Cat1"]
    }, {
    name: "AIG:Cat2.Placed"
    type: scale
    opt:  0.45
    children: [ "AIG:Cat2"]
    }, {
    name: "my:Cat1.Signed"
    type: scale
    opt:  0.06
    children: [ "AIG:Cat1"]
    }, {
    name: "my:Cat2.Signed"
    type: scale
    opt:  0.045
    children: [ "AIG:Cat2"]
    }, {
    name: "my:Program1"
    type: group
    children: [ "my:Cat1.Signed", "my:Cat2.Signed"]
    }, {
    name: "my:Assumed"
    type: group
    children: [ "my:Program1"]
    }, {
    name: "my:Our positions"
    type: comment
    }, {
    name: "AIG:AIG's positions"
    type: comment
    }
  ]
}
