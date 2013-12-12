{group, scale, contract, invert} = require '../ops'

exports.graph = {
  tag: "contract"
  dag: [ {
    name: "PortA"
    type: group
    }, {
    name: "TreatyB"
    type: contract
    opt: "10M xs 10M"
    children: [ "PortA" ]
    }
  ]
}
