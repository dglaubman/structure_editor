{group, scale, contract, invert, comment} = require '../ops'

exports.graph = {
  tag: "scor"
  dag: [ {
    name: "SCOR:SCOR Global"
    type: group
    children: ["UK:SCOR UK", "Reass:SCOR Reass"]
    }, {
    name: "UK:Specialty"
    type: group
    children: ["UK:SUL UK"]
    }, {
    name: "UK:Treaty"
    type: group
    children: ["UK:UK & Ireland"]
    }, {
    name: "UK:SCOR UK"
    type: group
    children: ["UK:Specialty","UK:Treaty"]
    }, {
    name: "UK:SUL UK"
    type: group
    opt: 1200000000
    }, {
    name: "UK:UK & Ireland"
    type: group
    opt: 2500000000
    }, {
    name: "Reass:SCOR Reass"
    type: group
    children: ["Reass:Specialty","Reass:Treaty"]
    }, {
    name: "Reass:Specialty"
    type: group
    children: ["Reass:Inwards Retro","Reass:Joburg", "Reass:Decennial"]
    }, {
    name: "Reass:Treaty"
    type: group
    children: ["Reass:BelgiumLux","Reass:France"]
    }, {
    name: "Reass:Decennial"
    type: group
    opt: 440000000
    }, {
    name: "Reass:Inwards Retro"
    type: group
    opt: 750000000
    }, {
    name: "Reass:Joburg"
    type: group
    opt: 980000000
    }, {
    name: "Reass:BelgiumLux"
    type: group
    opt: 1750000000
    }, {
    name: "Reass:France"
    type: group
    opt: 3000000000
    }
  ]
}