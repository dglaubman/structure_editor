_ = require("underscore")
fs = require("fs")

prefix = process.argv[2] or "."

out = (path, data) ->
  fs.writeFile( "#{prefix }/#{path}.json", data, (err) -> if err then throw err )

convert = ( g ) ->
  {name, states, links} = g
  width=1000
  height=600
  nodes = ({id: i, value: { label: state } } for state, i in states)
  ix = _.indexBy( nodes, (x) -> x.value.label )
  edges = ( { u: ix[link.u].id, v: ix[link.v].id, value: link.value } for link in links )
  out name, JSON.stringify {
    width
    height
    nodes
    edges
  }, undefined, 2

minus = "<span style='font-size:24px'>-</span>"
plus = "<span style='font-size:24px'>+</span>"
bluepill = "<span style='color:blue'>blue pill?</span>, default"
redpill = "<span style='color:red'>red pill?</span>"
choice =
  name: "choice"
  states: ["Acme:Cat1", "Acme:Cat2",  "Choose between Signed and Written shares", "My:Cat1.Signed", "My:Cat2.Signed", "My:Cat1.Written", "My:Cat2.Written",  "My:Signed", "My:Written", "My:AssumedChoice", "My:Assumed"  ]
  links: [     { u: "My:Cat1.Signed",   v: "Acme:Cat1",  value: { label: "6%" } },
    { u: "My:Cat2.Signed",   v: "Acme:Cat2",  value: { label: "4.5%" } },
    { u: "My:Cat1.Written",   v: "Acme:Cat1",  value: { label: "9%" } },
    { u: "My:Cat2.Written",   v: "Acme:Cat2",  value: { label: "7%" } },
    { u: "My:Signed",   v: "My:Cat1.Signed",  value: { label: plus } },
    { u: "My:Signed",   v: "My:Cat2.Signed",  value: { label: plus } },
    { u: "My:Written",   v: "My:Cat1.Written",  value: { label: plus } },
    { u: "My:Written",   v: "My:Cat2.Written",  value: { label: plus } },
    { u: "My:Assumed",   v: "My:AssumedChoice",  value: { label: plus } },
    { u: "My:AssumedChoice",   v: "My:Written",  value: { label: bluepill } },
    { u: "My:AssumedChoice",   v: "My:Signed",  value: { label: redpill } }
  ]

netpos =
  name: "netpos"
  states: [ "ABC, XYZ net of DEF, GHI", "ABC", "XYZ", "DEF", "GHI", "An example subject position" ]
  links:  [
    { u: "ABC, XYZ net of DEF, GHI",     v: "ABC",     value: { label: plus } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "XYZ",     value: { label: plus } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "DEF",     value: { label: minus } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "GHI",     value: { label: minus } }
  ]

placed =
  name: "placed"
  states: [ "Net", "Gross", "Ceded", "Fac", "PerRisk", "Cat", "Cat1", "Cat2", "Cat1.Placed", "Cat2.Placed", "Program1", "Placement of a Pro forma program (ACME namespace)" ]
  links: [
    { u: "Net",     v: "Gross",     value: { label: plus } },
    { u: "Net",     v: "Ceded",   value: { label: minus } },
    { u: "Ceded",     v: "Fac",   value: { label: plus } },
    { u: "Ceded",     v: "PerRisk",     value: { label: plus } },
    { u: "Ceded",   v: "Cat",  value: { label: plus } },
    { u: "Cat",   v: "Cat1.Placed",  value: { label: plus } },
    { u: "Cat",   v: "Cat2.Placed",  value: { label: plus } },
    { u: "Cat1.Placed",   v: "Cat1",  value: { label: "30%" } },
    { u: "Cat2.Placed",   v: "Cat2",  value: { label: "45%" } },
    { u: "Program1",   v: "Cat1",  value: { label: plus } },
    { u: "Program1",   v: "Cat2",  value: { label: plus } }
  ]


program =
  name: "program"
  states: [  "ABC, XYZ net of DEF, GHI", "ABC", "XYZ", "DEF", "GHI", "Cat1", "Cat2", "Program1","A Cat Program with 2 Cat treaties" ]
  links: [
    { u: "ABC, XYZ net of DEF, GHI",     v: "ABC",     value: { label: plus } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "XYZ",     value: { label: plus } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "DEF",     value: { label: minus } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "GHI",     value: { label: minus } },
    { u: "Cat1", v: "ABC, XYZ net of DEF, GHI",     value: { label: " 10 x 10" } },
    { u: "Cat2", v: "ABC, XYZ net of DEF, GHI",     value: { label: " 10 x 20" } },
    { u: "Program1", v: "Cat1",     value: { label: plus } },
    { u: "Program1", v: "Cat2",     value: { label: plus } }
  ]

standard =
  name: "standard"
  states: [ "Net", "Gross", "Ceded", "Fac", "PerRisk", "Cat", "Standard Postions (All in ACME namespace)" ]
  links: [
    { u: "Net",     v: "Gross",     value: { label: plus } },
    { u: "Net",     v: "Ceded",   value: { label: minus } },
    { u: "Ceded",     v: "Fac",   value: { label: plus } },
    { u: "Ceded",     v: "PerRisk",     value: { label: plus } },
    { u: "Ceded",   v: "Cat",  value: { label: plus } }
  ]

cat =
  name: "cat"
  states: [ "Cat1", "ABC, XYZ net of DEF, GHI", "ABC", "XYZ", "DEF", "GHI", "A Cat treaty against a subject position" ]
  links: [
    { u: "ABC, XYZ net of DEF, GHI",     v: "ABC",     value: { label: plus } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "XYZ",     value: { label: plus } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "DEF",     value: { label: minus } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "GHI",     value: { label: minus } },
    { u: "Cat1", v: "ABC, XYZ net of DEF, GHI",     value: { label: " 10 x 10" } } ]

qs =
  name: "qs"
  states: [ "PortA", "PortA { LOB is Comm }", "QS1", "PerRisk", "Quota share against a filtered position" ]
  links: [
    { v: "PortA",     u: "PortA { LOB is Comm }",     value: { label: "{ LOB is Comm }" } },
    { v: "PortA { LOB is Comm }",     u: "QS1",     value: { label: "20%, Occ lim 1M" } },
    { v: "QS1",     u: "PerRisk",     value: { label: plus } }
  ]

assumed =
  name: "assumed"
  states: [ "Net", "Gross", "Ceded", "Fac", "PerRisk", "Cat", "Cat1", "Cat2", "Cat1.Placed", "Cat2.Placed", "Program1", "My signed share of Acme's pro forma program", "My:Cat1.Signed", "My:Cat2.Signed", "My:Assumed", "My:Program1" ]
  links: [
    { u: "Net",     v: "Gross",     value: { label: plus } },
    { u: "Net",     v: "Ceded",   value: { label: minus } },
    { u: "Ceded",     v: "Fac",   value: { label: plus } },
    { u: "Ceded",     v: "PerRisk",     value: { label: plus } },
    { u: "Ceded",   v: "Cat",  value: { label: plus } },
    { u: "Cat",   v: "Cat1.Placed",  value: { label: plus } },
    { u: "Cat",   v: "Cat2.Placed",  value: { label: plus } },
    { u: "Cat1.Placed",   v: "Cat1",  value: { label: "30%" } },
    { u: "Cat2.Placed",   v: "Cat2",  value: { label: "45%" } },
    { u: "My:Cat1.Signed",   v: "Cat1",  value: { label: "6%" } },
    { u: "My:Cat2.Signed",   v: "Cat2",  value: { label: "4.5%" } },
    { u: "My:Program1",   v: "My:Cat1.Signed",  value: { label: plus } },
    { u: "My:Program1",   v: "My:Cat2.Signed",  value: { label: plus } },
    { u: "My:Assumed",   v: "My:Program1",  value: { label: plus } },
    { u: "Program1",   v: "Cat1",  value: { label: plus } },
    { u: "Program1",   v: "Cat2",  value: { label: plus } }
  ]

contract =
  name: "contract"
  states: [ "PortA", "TreatyB",  "A contract takes a position as its subject, and writes to its output position" ]
  links: [    { v: "PortA",     u: "TreatyB",     value: { label: "10x10, subject is portA, name is TreatyB" } } ]

sumnet =
  name: "sumnet"
  states: [ "A", "B", "C", "D", "A net of B", "C.PreCat", "Cat1", "A.PreCat", "PreCat" ]
  links: [ { u: "B", v: "A", value: { label: "1x1p.r." } },
           { u: "D", v: "C", value: { label: "10% share" } },
           { u: "A net of B", v: "A", value: { label: plus } },
           { u: "A net of B", v: "B", value: { label: minus } },
           { v: "A net of B", u: "A.PreCat", value: { label: "105%" } },
           { u: "C.PreCat", v: "C", value: { label: plus } },
           { u: "C.PreCat", v: "D", value: { label: minus } },
           { u: "PreCat", v: "A.PreCat", value: { label: plus } },
           { u: "PreCat", v: "C.PreCat", value: { label: plus } },
           { u: "Cat1", v: "PreCat", value: { label: "10Mx10M, 4M agg ded" } } ]
  

sumnet2 =
  name: "sumnet2"
  states: [ "A", "B", "C", "D", "A net of B,D", "C.PreCat", "Cat1", "A.PreCat", "PreCat" ]
  links: [ { u: "B", v: "A", value: { label: "1x1p.r." } },
           { u: "D", v: "C", value: { label: "10% share" } },
           { u: "A net of B,D", v: "A", value: { label: plus } },
           { u: "A net of B,D", v: "B", value: { label: minus } },
           { u: "A net of B,D", v: "D", value: { label: minus } },
           { v: "A net of B,D", u: "A.PreCat", value: { label: "105%" } },
           { u: "C.PreCat", v: "C", value: { label: plus } },
           { u: "C.PreCat", v: "D", value: { label: minus } },
           { u: "PreCat", v: "A.PreCat", value: { label: plus } },
           { u: "PreCat", v: "C.PreCat", value: { label: plus } },
           { u: "Cat1", v: "PreCat", value: { label: "10Mx10M, 4M agg ded" } } ]
  

graphs = [ contract,  standard, qs, netpos, cat, program, placed, assumed, choice, sumnet, sumnet2 ]
convert graph for graph in graphs
