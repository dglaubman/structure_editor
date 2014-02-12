fs = require 'fs'
compile = require '../src/backend'

{fatal, trace, logger} = require '../src/log'
{argv} = require 'optimist'

logger argv
filename = argv.i || fatal "compile_structure: Must specify '-i <structure file>'"

text = fs.readFileSync filename, 'utf-8'
trace compile text


