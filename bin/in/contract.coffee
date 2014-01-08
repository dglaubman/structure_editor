{group, scale, contract, invert, comment} = require '../ops'

exports.graph = {
  tag: "contract"
  dag: [ {
    name: "CedantA:PortA"
    type: group
    opt: 25000000
    }, {
    name: "Our:TreatyB"
    type: contract
    opt: "10M xs 10M"
    children: [ "CedantA:PortA" ]
    }, {
    name: "CedantA:CedantA"
    type: comment
    }, {
    name: "Our:Our position"
    type: comment
    }
  ]
}
