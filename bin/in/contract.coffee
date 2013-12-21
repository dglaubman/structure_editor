{group, scale, contract, invert} = require '../ops'

exports.graph = {
  tag: "contract"
  dag: [ {
    name: "PortA"
    type: group
    opt: 25000000
    }, {
    name: "TreatyB"
    type: contract
    opt: "10M xs 10M"
    children: [ "PortA" ]
    }
  ]
}
