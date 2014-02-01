{group, scale, contract, invert, comment} = require '../ops'

exports.graph = {
  tag: "travelers"
  dag: [ {
    name: "Out:Fac"
    type: group
    children: ["Out:F1", "Out:F2", "Out:F3"]
    }, {
    name: "Out:PerRisk"
    type: group
    children: ["Out:PPR_Layer1", "Out:Fac", "Out:SST"]
    }, {
    name: "Book"
    type: group
    opt: 50000000
    }, {
    name: "Out:F1"
    type: contract
    opt: "4M xs 4M"
    children: ["Book"]
    }, {
    name: "Out:F2"
    type: contract
    opt: "4M xs 1M"
    children: ["Book"]
    }, {
    name: "Out:F3"
    type: contract
    opt: "10M xs 15M"
    children: ["Book"]
    }, {
    name: "Out:HighFac"
    type: group
    children: ["Out:F3"]
    }, {
    name: "Out:PPR_Layer1"
    type: contract
    opt:  "20 xs 15 per risk"
    children: ["Book net of SST, HighFac"]
    }, {
    name: "Out:SST"
    type: contract
    opt: "50% w/ 50M occ"
    children: ["Book net of Fac"]
    }, {
    name: "Book net of Fac"
    type: group
    children: ["Book", "~Out:Fac"]
    }, {
    name: "~Out:Fac"
    type: invert
    children: ["Out:Fac"]
    }, {
    name: "~Out:SST"
    type: invert
    children: [ "Out:SST" ]
    }, {
    name: "~Out:HighFac"
    type: invert
    children: [ "Out:HighFac" ]
    }, {
    name: "Book net of SST, HighFac"
    type: group
    children: ["Book", "~Out:SST", "~Out:HighFac"]
    }, {
    name: "Out:Outward positions"
    type: comment
  }
  ]
}