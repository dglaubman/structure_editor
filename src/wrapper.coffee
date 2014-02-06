fs = require 'fs'
parser = require( '../public/js/pgl-ast')

{log, fatal, trace, logger} = require './log'
{argv} = require 'optimist'

logger argv
filename = argv.i || fatal "Must specify '-i <structure file>'"
text = fs.readFileSync filename, 'utf-8'
trace parser.parse text


