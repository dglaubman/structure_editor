{group, scale, contract, invert, filter} = require '../ops'

exports.graph = {
  tag: "qs"
  dag: [ {
    name: "QS"
    type: contract
    opt: "30% Share"
    children: ["PortA.Comm"]
    }, {
    name: "PortA"
    type: group
    }, {
    name: "PortA.Comm"
    type: filter
    opt: "{ COB is COMM }"
    children: [ "PortA" ]
    }
  ]
}
