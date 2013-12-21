{group, scale, contract, invert} = require '../ops'

exports.graph = {
  tag: "standard"
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
    name: "Gross"
    type: group
    children: [ "Direct", "Assumed"]
    }, {
    name: "Direct"
    type: group
    opt: 50000000
    }, {
    name: "Assumed"
    type: group
    opt: 20000000
    }, {
    name: "Fac"
    type: group
    opt: 5000000
    }, {
    name: "PerRisk"
    type: group
    opt: 12000000
    }, {
    name: "Cat"
    type: group
    opt: 10000000
    }
  ]
}
