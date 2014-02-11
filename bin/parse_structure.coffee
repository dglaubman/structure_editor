fs = require 'fs'
{parse} = require '../public/js/structure_parser.js'

{fatal, trace, logger} = require '../src/log'
{argv} = require 'optimist'

logger argv
filename = argv.i || fatal "parse_structure: Must specify '-i <structure file>'"
text = fs.readFileSync filename, 'utf-8'
trace parse text


