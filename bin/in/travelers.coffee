{group, scale, contract, invert} = require '../ops'

exports.graph = {
  tag: "travelers"
  dag: [ {
    name: "Fac"
    type: group
    children: ["F1", "F2", "F3"]
    }, {
    name: "PerRisk"
    type: group
    children: ["PPR_Layer1", "Fac", "SST"]
    }, {
    name: "Book"
    type: group
    opt: 50000000
    }, {
    name: "F1"
    type: contract
    opt: "4M xs 4M"
    children: ["Book"]
    }, {
    name: "F2"
    type: contract
    opt: "4M xs 1M"
    children: ["Book"]
    }, {
    name: "F3"
    type: contract
    opt: "10M xs 15M"
    children: ["Book"]
    }, {
    name: "HighFac"
    type: group
    children: ["F3"]
    }, {
    name: "PPR_Layer1"
    type: contract
    opt:  "20 xs 15 per risk"
    children: ["Book net of SST, HighFac"]
    }, {
    name: "SST"
    type: contract
    opt: "50% w/ 50M occ"
    children: ["Book net of Fac"]
    }, {
    name: "Book net of Fac"
    type: group
    children: ["Book", "~Fac"]
    }, {
    name: "~Fac"
    type: invert
    children: ["Fac"]
    }, {
    name: "~SST"
    type: invert
    children: [ "SST" ]
    }, {
    name: "~HighFac"
    type: invert
    children: [ "HighFac" ]
    }, {
    name: "Book net of SST, HighFac"
    type: group
    children: ["Book", "~SST", "~HighFac"]
    }
  ]
}