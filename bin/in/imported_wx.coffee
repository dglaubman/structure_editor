{group, scale, contract, invert, comment} = require '../ops'

exports.graph = {
  tag: "imported_wx"
  dag : [ {
    name: "Acme:Net"
    type: group
    children: [ "Acme:Gross", "~Acme:Ceded" ]
    }, {
    name: "Acme:Gross"
    type: group
    children: [ "Acme:PortA" ]
    }, {
    name: "Acme:PortA"
    type: group
    opt: 25000000
    }, {
    name: "~Acme:Ceded"
    type: invert
    children: [ "Acme:Ceded" ]
    }, {
    name: "Acme:Ceded"
    type: group
    children: [ "Acme:Fac", "Acme:PerRisk", "Acme:Cat" ]
    }, {
    name: "Acme:Cat"
    type: group
    }, {
    name: "Acme:PerRisk"
    type: group
    children: [ "Acme:WX1.Placed" ]
    }, {
    name: "Acme:Fac"
    type: group
    }, {
    name: "Acme:WX1.Placed"
    type: scale
    children: [ "Market:WX1" ]
    opt: 0.4
    }, {
    name: "Market:WX1"
    type: contract
    children: [ "Acme:PortA" ]
    opt: "10M xs 10M"
    }, {
    name: "Our:Net"
    type: group
    children: [ "Our:Assumed", "~Our:Ceded" ]
    }, {
    name: "~Our:Ceded"
    type: invert
    children: [ "Our:Ceded" ]
    }, {
    name: "Our:Assumed"
    type: group
    children: [ "Our:WX1.Signed" ]
    }, {
    name: "Our:Ceded"
    type: group
    children: [ "Our:WX1.Ceded" ]
    }, {
    name: "Our:WX1.Ceded"
    type: scale
    children: [ "Our:WX1.Signed" ]
    opt: 0.5
    }, {
    name: "Our:WX1.Signed"
    type: scale
    children: [ "Market:WX1" ]
    opt: 0.07
    }, {
    name: "Our:Our positions"
    type: comment
    }, {
    name: "Market:Market"
    type: comment
    }, {
    name: "Acme:Acme"
    type: comment
    }
  ]
}

