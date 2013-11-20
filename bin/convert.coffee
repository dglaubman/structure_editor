_ = require("underscore")
fs = require("fs")
{trace, logger} = require './log'
{argv} = require 'optimist'

prefix = process.argv[2] or "."
logger argv
out = (path, data) ->
  fs.writeFile( "#{prefix }/#{path}.json", data, (err) -> if err then throw err )

convert = ( g ) ->
  {name, states, links} = g
  nodes = ({id: i, value: { label: state } } for state, i in states)
  ix = _.indexBy( nodes, (x) -> x.value.label )
  try
    edges = ( { u: ix[link.u].id, v: ix[link.v].id, value: link.value } for link in links )
  catch e
    trace edges
  out name, JSON.stringify {
    nodes
    edges
  }, undefined, 2

choice =
  name: "choice"
  states: ["Acme:Cat1", "Acme:Cat2",  "Choose between Signed and Written shares", "My:Cat1.Signed", "My:Cat2.Signed", "My:Cat1.Written", "My:Cat2.Written",  "My:Signed", "My:Written", "My:AssumedChoice", "My:Assumed"  ]
  links: [     { u: "My:Cat1.Signed",   v: "Acme:Cat1",  value: { type: 'scale', label: "6%" } },
    { u: "My:Cat2.Signed",   v: "Acme:Cat2",  value: {  type: 'scale', label: "4.5%" } },
    { u: "My:Cat1.Written",   v: "Acme:Cat1",  value: {  type: 'scale', label: "9%" } },
    { u: "My:Cat2.Written",   v: "Acme:Cat2",  value: {  type: 'scale', label: "7%" } },
    { u: "My:Signed",   v: "My:Cat1.Signed",  value: { type: 'group', label: '+' } },
    { u: "My:Signed",   v: "My:Cat2.Signed",  value: { type: 'group', label: '+' } },
    { u: "My:Written",   v: "My:Cat1.Written",  value: { type: 'group', label: '+' } },
    { u: "My:Written",   v: "My:Cat2.Written",  value: { type: 'group', label: '+' } },
    { u: "My:Assumed",   v: "My:AssumedChoice",  value: { type: 'group', label: '+' } },
    { u: "My:AssumedChoice",   v: "My:Written",  value: { type: 'choose', label: "quoted" } },
    { u: "My:AssumedChoice",   v: "My:Signed",  value: { type: 'choose', tag: "default", label: "default, bound " } }
  ]

netpos =
  name: "netpos"
  states: [ "ABC, XYZ net of DEF, GHI", "ABC", "XYZ", "DEF", "GHI", "An example subject position" ]
  links:  [
    { u: "ABC, XYZ net of DEF, GHI",     v: "ABC",     value: { type: 'group', label: '+' } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "XYZ",     value: { type: 'group', label: '+' } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "DEF",     value: { type: 'invert', label: '-' } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "GHI",     value: { type: 'invert', label: '-' } }
  ]

imported_wx =
  name: "imported_wx"
  states: [ "Acme:Net", "Acme:Gross", "Acme:Ceded", "Acme:Fac", "Acme:PerRisk", "Acme:Cat", "Market:WX1", "Acme:WX1.Placed", "Our:WX1.Signed", "Our:Assumed", "Our:Ceded", "Our:Net", "Our:WX1.Ceded", "Acme:PortA" ]
  links: [
    { u: "Market:WX1",     v: "Acme:PortA",     value: { type: 'contract', label: "1x1 per risk" } },
    { u: "Acme:Gross",     v: "Acme:PortA",     value: { type: 'group', label: '+' } },
    { u: "Acme:Net",     v: "Acme:Gross",     value: { type: 'group', label: '+' } },
    { u: "Acme:Net",     v: "Acme:Ceded",   value: { type: 'invert', label: '-' } },
    { u: "Acme:Ceded",     v: "Acme:Fac",   value: { type: 'group', label: '+' } },
    { u: "Acme:Ceded",     v: "Acme:PerRisk",     value: { type: 'group', label: '+' } },
    { u: "Acme:Ceded",   v: "Acme:Cat",  value: { type: 'group', label: '+' } },
    { u: "Acme:PerRisk",   v: "Acme:WX1.Placed",  value: { type: 'group', label: '+' } },
    { u: "Acme:WX1.Placed",   v: "Market:WX1",  value: {  type: 'scale', label: "40%" } },
    { u: "Our:WX1.Signed",   v: "Market:WX1",  value: {  type: 'scale', label: "7%" } },
    { u: "Our:Assumed",   v: "Our:WX1.Signed",  value: { type: 'group', label: '+' } },
    { u: "Our:WX1.Ceded",   v: "Our:WX1.Signed",  value: {  type: 'scale', label: "50%" } },
    { u: "Our:Ceded",   v: "Our:WX1.Ceded",  value: { type: 'group', label: '+' } },
    { u: "Our:Net",   v: "Our:Assumed",  value: { type: 'group', label: '+' } },
    { u: "Our:Net",   v: "Our:Ceded",  value: { type: 'invert', label: '-' } }
  ]

imported_wx2 =
  name: "imported_wx2"
  states: [ "Acme:Net", "Acme:Gross", "Acme:Ceded", "Acme:Fac", "Acme:PerRisk", "Acme:Cat", "Acme:WX1", "Our:WX1.Signed", "Our:Assumed", "Our:Ceded", "Our:Net", "Our:WX1.Ceded", "Acme:PortA" ]
  links: [
    { u: "Acme:WX1",     v: "Acme:PortA",     value: { type: 'contract', label: "40% of 1x1 per risk" } },
    { u: "Acme:Gross",     v: "Acme:PortA",     value: { type: 'group', label: '+' } },
    { u: "Acme:Net",     v: "Acme:Gross",     value: { type: 'group', label: '+' } },
    { u: "Acme:Net",     v: "Acme:Ceded",   value: { type: 'invert', label: '-' } },
    { u: "Acme:Ceded",     v: "Acme:Fac",   value: { type: 'group', label: '+' } },
    { u: "Acme:Ceded",     v: "Acme:PerRisk",     value: { type: 'group', label: '+' } },
    { u: "Acme:Ceded",   v: "Acme:Cat",  value: { type: 'group', label: '+' } },
    { u: "Acme:PerRisk",   v: "Acme:WX1",  value: { type: 'group', label: '+' } },
    { u: "Our:WX1.Signed",   v: "Acme:WX1",  value: { type: 'contract', label: "2.8% (7% of 40%)" } },
    { u: "Our:Assumed",   v: "Our:WX1.Signed",  value: { type: 'group', label: '+' } },
    { u: "Our:WX1.Ceded",   v: "Our:WX1.Signed",  value: {  type: 'scale', label: "50%" } },
    { u: "Our:Ceded",   v: "Our:WX1.Ceded",  value: { type: 'group', label: '+' } },
    { u: "Our:Net",   v: "Our:Assumed",  value: { type: 'group', label: '+' } },
    { u: "Our:Net",   v: "Our:Ceded",  value: { type: 'invert', label: '-' } }
  ]
placed =
  name: "placed"
  states: [ "Net", "Gross", "Ceded", "Fac", "PerRisk", "Cat", "Cat1", "Cat2", "Cat1.Placed", "Cat2.Placed", "Program1", "Placement of a Pro forma program (ACME namespace)" ]
  links: [
    { u: "Net",     v: "Gross",     value: { type: 'group', label: '+' } },
    { u: "Net",     v: "Ceded",   value: { type: 'invert', label: '-' } },
    { u: "Ceded",     v: "Fac",   value: { type: 'group', label: '+' } },
    { u: "Ceded",     v: "PerRisk",     value: { type: 'group', label: '+' } },
    { u: "Ceded",   v: "Cat",  value: { type: 'group', label: '+' } },
    { u: "Cat",   v: "Cat1.Placed",  value: { type: 'group', label: '+' } },
    { u: "Cat",   v: "Cat2.Placed",  value: { type: 'group', label: '+' } },
    { u: "Cat1.Placed",   v: "Cat1",  value: {  type: 'scale', label: "30%" } },
    { u: "Cat2.Placed",   v: "Cat2",  value: {  type: 'scale', label: "45%" } },
    { u: "Program1",   v: "Cat1",  value: { type: 'group', label: '+' } },
    { u: "Program1",   v: "Cat2",  value: { type: 'group', label: '+' } }
  ]

travelers =
  name: "travelers"
  states: [ "Fac", "PerRisk", "Book", "F1", "F2", "F3", "HighFac", "SST", "PPR Layer1", "Book net of Fac", "Book net of SST, HighFac"]
  links: [
    { u: "F1",                  v: "Book",      value: { type: 'contract', label: '4M xs 1M' } },
    { u: "F2",                  v: "Book",      value: { type: 'contract', label: '4M xs 4M' } },
    { u: "F3",                  v: "Book",      value: {  type: 'contract', label: "10M xs 15M" } },
    { u: "Fac",                 v: "F1",        value: {  type: 'group', label: "+" } },
    { u: "Fac",                 v: "F2",        value: {  type: 'group', label: "+" } },
    { u: "Fac",                 v: "F3",        value: {  type: 'group', label: "+" } },
    { u: "HighFac",             v: "F3",        value: {  type: 'group', label: "+" } },
    { u: "Book net of Fac",     v: "Book",      value: {  type: 'group', label: "+" } },
    { u: "Book net of Fac",     v: "Fac",       value: {  type: 'invert', label: "-" } },
    { u: "SST",                 v: "Book net of Fac", value: { type: 'contract', label: '50% (50M Occ)' } },
    { u: "Book net of SST, HighFac",  v: "Book",      value: { type: 'group', label: '+' } },
    { u: "Book net of SST, HighFac",  v: "HighFac",   value: {  type: 'invert', label: "-" } },
    { u: "Book net of SST, HighFac",  v: "SST",       value: {  type: 'invert', label: "-" } },
    { u: "PPR Layer1",         v: "Book net of SST, HighFac",  value: { type: 'contract', label: '20M xs 15 p.r.' } },
    { u: "PerRisk",             v: "PPR Layer1", value: { type: 'group', label: '+' } },
    { u: "PerRisk",             v: "SST",       value: { type: 'group', label: '+' } },
    { u: "PerRisk",             v: "Fac",       value: { type: 'group', label: '+' } }
  ]

program =
  name: "program"
  states: [  "ABC, XYZ net of DEF, GHI", "ABC", "XYZ", "DEF", "GHI", "Cat1", "Cat2", "Program1","A Cat Program with 2 Cat treaties" ]
  links: [
    { u: "ABC, XYZ net of DEF, GHI",     v: "ABC",     value: { type: 'group', label: '+' } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "XYZ",     value: { type: 'group', label: '+' } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "DEF",     value: { type: 'invert', label: '-' } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "GHI",     value: { type: 'invert', label: '-' } },
    { u: "Cat1", v: "ABC, XYZ net of DEF, GHI",     value: { type: 'contract', label: " 10 x 10" } },
    { u: "Cat2", v: "ABC, XYZ net of DEF, GHI",     value: { type: 'contract', label: " 10 x 20" } },
    { u: "Program1", v: "Cat1",     value: { type: 'group', label: '+' } },
    { u: "Program1", v: "Cat2",     value: { type: 'group', label: '+' } }
  ]

standard =
  name: "standard"
  states: [ "Net", "Gross", "Ceded", "Fac", "PerRisk", "Cat", "Standard Postions (All in ACME namespace)" ]
  links: [
    { u: "Net",     v: "Gross",     value: { type: 'group', label: '+' } },
    { u: "Net",     v: "Ceded",   value: { type: 'invert', label: '-' } },
    { u: "Ceded",     v: "Fac",   value: { type: 'group', label: '+' } },
    { u: "Ceded",     v: "PerRisk",     value: { type: 'group', label: '+' } },
    { u: "Ceded",   v: "Cat",  value: { type: 'group', label: '+' } }
  ]

cat =
  name: "cat"
  states: [ "Cat1", "ABC, XYZ net of DEF, GHI", "ABC", "XYZ", "DEF", "GHI", "A Cat treaty against a subject position" ]
  links: [
    { u: "ABC, XYZ net of DEF, GHI",     v: "ABC",     value: { type: 'group', label: '+' } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "XYZ",     value: { type: 'group', label: '+' } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "DEF",     value: { type: 'invert', label: '-' } },
    { u: "ABC, XYZ net of DEF, GHI",     v: "GHI",     value: { type: 'invert', label: '-' } },
    { u: "Cat1", v: "ABC, XYZ net of DEF, GHI",     value: { type: 'contract', label: " 10 x 10" } } ]

qs =
  name: "qs"
  states: [ "PortA", "PortA { LOB is Comm }", "QS1", "PerRisk", "Quota share against a filtered position" ]
  links: [
    { v: "PortA",     u: "PortA { LOB is Comm }",     value: { type: 'filter', label: "{ LOB is Comm }" } },
    { v: "PortA { LOB is Comm }",     u: "QS1",     value: { type: 'contract', label: "20%, Occ lim 1M" } },
    { v: "QS1",     u: "PerRisk",     value: { type: 'group', label: '+' } }
  ]

assumed =
  name: "assumed"
  states: [ "Net", "Gross", "Ceded", "Fac", "PerRisk", "Cat", "Cat1", "Cat2", "Cat1.Placed", "Cat2.Placed", "Program1", "My signed share of Acme's pro forma program", "My:Cat1.Signed", "My:Cat2.Signed", "My:Assumed", "My:Program1" ]
  links: [
    { u: "Net",     v: "Gross",     value: { type: 'group', label: '+' } },
    { u: "Net",     v: "Ceded",   value: { type: 'invert', label: '-' } },
    { u: "Ceded",     v: "Fac",   value: { type: 'group', label: '+' } },
    { u: "Ceded",     v: "PerRisk",     value: { type: 'group', label: '+' } },
    { u: "Ceded",   v: "Cat",  value: { type: 'group', label: '+' } },
    { u: "Cat",   v: "Cat1.Placed",  value: { type: 'group', label: '+' } },
    { u: "Cat",   v: "Cat2.Placed",  value: { type: 'group', label: '+' } },
    { u: "Cat1.Placed",   v: "Cat1",  value: {  type: 'scale', label: "30%" } },
    { u: "Cat2.Placed",   v: "Cat2",  value: {  type: 'scale', label: "45%" } },
    { u: "My:Cat1.Signed",   v: "Cat1",  value: {  type: 'scale', label: "6%" } },
    { u: "My:Cat2.Signed",   v: "Cat2",  value: {  type: 'scale', label: "4.5%" } },
    { u: "My:Program1",   v: "My:Cat1.Signed",   value: { type: 'scale', type: 'group', label: '+' } },
    { u: "My:Program1",   v: "My:Cat2.Signed",  value: { type: 'group', label: '+' } },
    { u: "My:Assumed",   v: "My:Program1",  value: { type: 'group', label: '+' } },
    { u: "Program1",   v: "Cat1",  value: { type: 'group', label: '+' } },
    { u: "Program1",   v: "Cat2",  value: { type: 'group', label: '+' } }
  ]

contract =
  name: "contract"
  states: [ "PortA", "TreatyB",  "A contract takes a position as its subject, and writes to its output position" ]
  links: [    { v: "PortA",     u: "TreatyB",     value: { type: 'contract', label: "10x10, subject is portA, name is TreatyB" } } ]

sumnet =
  name: "sumnet"
  states: [ "A", "B", "C", "D", "A net of B", "C.PreCat", "Cat1", "A.PreCat", "PreCat" ]
  links: [ { u: "B", v: "A", value: { type: 'contract', label: "1x1p.r." } },
           { u: "D", v: "C", value: { type: 'contract', label: "10% share" } },
           { u: "A net of B", v: "A", value: { type: 'group', label: '+' } },
           { u: "A net of B", v: "B", value: { type: 'invert', label: '-' } },
           { v: "A net of B", u: "A.PreCat", value: { type: 'scale', label: "105%" } },
           { u: "C.PreCat", v: "C", value: { type: 'group', label: '+' } },
           { u: "C.PreCat", v: "D", value: { type: 'invert', label: '-' } },
           { u: "PreCat", v: "A.PreCat", value: { type: 'group', label: '+' } },
           { u: "PreCat", v: "C.PreCat", value: { type: 'group', label: '+' } },
           { u: "Cat1", v: "PreCat", value: { type: 'contract', label: "10Mx10M, 4M agg ded" } } ]


sumnet2 =
  name: "sumnet2"
  states: [ "A", "B", "C", "D", "A net of B,D", "A,C", "C net of D", "C.PreCat", "Cat1", "A.PreCat", "PreCat" ]
  links: [ { u: "B", v: "A", value: { type: 'contract', label: "1x1p.r." } },
           { u: "D", v: "A,C", value: { type: 'contract', label: "10% share" } },
           { u: "A,C", v: "C", value: { type: 'group', label: '+' } },
           { u: "A,C", v: "A", value: { type: 'group', label: '+' } },
           { u: "A net of B,D", v: "A", value: { type: 'group', label: '+' } },
           { u: "A net of B,D", v: "B", value: { type: 'invert', label: '-' } },
           { u: "A net of B,D", v: "D", value: { type: 'invert', label: '-' } },
           { v: "A net of B,D", u: "A.PreCat", value: { type: 'scale', label: "105%" } },
           { u: "C net of D", v: "C", value: { type: 'group', label: '+' } },
           { u: "C net of D", v: "D", value: { type: 'invert', label: '-' } },
           { u: "C.PreCat", v: "C net of D", value: { type: 'scale', label: "100%" } },
           { u: "PreCat", v: "A.PreCat", value: { type: 'group', label: '+' } },
           { u: "PreCat", v: "C.PreCat", value: { type: 'group', label: '+' } },
           { u: "Cat1", v: "PreCat", value: { type: 'contract', label: "10Mx10M, 4M agg ded" } } ]


graphs = [ contract,  standard, qs, netpos, cat, program, placed, assumed, choice, sumnet, sumnet2, imported_wx, imported_wx2, travelers ]
convert graph for graph in graphs
