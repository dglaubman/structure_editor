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
    }, {
    name: "Assumed"
    type: group
    }, {
    name: "Fac"
    type: group
    }, {
    name: "PerRisk"
    type: group
    }, {
    name: "Cat"
    type: group
    }
  ]
}
