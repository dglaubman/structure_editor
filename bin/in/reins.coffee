{group, scale, contract, invert} = require '../ops'

exports.graph = {
  tag: "reins"
  dag: [ {
    name: "Ceded"
    type: group
    children: [ "Fac", "PerRisk", "Cat"]
    }, {
    name: "Fac"
    type: group
    children: ["Fac1"]
    }, {
    name: "PerRisk"
    type: group
    children: ["SST", "PRT"]
    }, {
    name: "~Fac"
    type: invert
    children: ["Fac"]
    }, {
    name: "Gross net of SST"
    type: group
    children: ["Gross", "~SST"]
    }, {
    name: "~SST"
    type: invert
    children: ["SST"]
    }, {
    name: "PRT"
    type: contract
    opt: "20M xs 15M per risk"
    children: ["Gross net of SST"]
    }, {
    name: "Fac1"
    type: contract
    opt: "1M xs 1M {IBM Acct)"
    children: ["Gross"]
    }, {
    name: "SST"
    type: contract
    opt: "4 lines @ 250K "
    children: ["Gross net of Fac"]
    }, {
    name: "Gross net of Fac"
    type: group
    children: ["Gross", "~Fac"]
    }, {
    name: "Cat"
    type: group
    children: [ "Cat1.Placed", "Cat2.Placed"]
    }, {
    name: "Cat1.Placed"
    type: scale
    opt: 0.3
    children: [ "Cat1"]
    }, {
    name: "Cat2.Placed"
    type: scale
    opt: 0.45
    children: [ "Cat2"]
    }, {
    name: "Cat1"
    type: contract
    opt: "20M xs 5M Wind"
    children: [ "Gross"]
    }, {
    name: "Cat2"
    type: contract
    opt: "10M xs 10M"
    children: [ "Gross"]
    }, {
    name: "Gross"
    type: group
    opt: 40000000
    }
  ]
}
