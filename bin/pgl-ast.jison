%lex
%options case-insensitive

alpha                 [a-z]
digit		      [0-9]
id		      [a-z][a-z0-9:_/.]*

%%

\s+		      return ''

"is"		      return 'IS'
"structure"	      return 'STRUCTURE'

/* mini-cdl */
"contract"	      return 'CONTRACT'
"declarations"	      return 'DECLARATIONS'
"covers"	      return 'COVERS'
"share"		      return 'SHARE'
"of"                  return 'OF'
"xs"		      return 'XS'

"+"		      return 'PLUS'
"-"		      return 'MINUS'
"*"		      return 'TIMES'
"/"		      return 'DIV'
"@"		      return 'AT'
"%"                   return 'PERCENT'

{id}		      return 'WORD'		      
{digit}+"."?{digit}*  return 'NUMBER'
"{"[^}]*"}"	      return 'PHRASE'

/lex

%start structure

%{
   // NodeTime profiling
   // require('nodetime').profile({
   //    accountKey: 'd161d32d678546ebbc43c3ac70a40e523d9d6093', 
   //    appName: 'PGL Application'
   //    });

    var under = require( 'underscore' );

    var inversions = [];
    function invert( element ) {
    	this.push( [ "~" + element, "invert", [ element ] ] )
    }

    var trace = function() {
    	var start = process.hrtime();
	var error = require('util').error;
	return function( msg ) {
	   var elapsed = process.hrtime( start );
	   error( elapsed[0] + "." + Math.floor( elapsed[1] / 1e6 ) + " s: " + msg );
	}
    }();

    function unwrap( phrase ) {
        var parts = phrase.split( /[}{]/ );
	require('assert').equal( parts.length, 3, "Phrase be surrounded by curlybraces" );
	return parts[1].trim();
    }

    function pretty( o ) {
        return JSON.stringify( o, undefined, 2)
    }

    function printGraph( positions ) {
    	trace( "generated positions" );
    	var tmp = pretty( positions )
	trace( "generated JSON" );
        console.log( tmp );
	trace( "done" );
    }

%}

%%
/* rules */
structure :
    STRUCTURE positions	contracts	
    	      			{ inversions.forEach(invert, $2); printGraph( $2.concat( $3 ) ) }
    ;

positions : 
    position			{ $$ = [ $1 ] } 		
    | positions position	{ $1.push( $2 ); $$ = $1 }
    ;

position :
    name IS expression		{ $3[0] = $1; $$ = $3 }
    ;

name : 
    WORD
    | PHRASE                    { $$ = unwrap( $1 ) }
    ;

expression :
    group			{ $$ = [ null, "group", $1 ] }
    | scale
    | filter
    | leaf			{ $$ = [ null, "group", [], $1 ] }
    ;

group :
    name			{ $$ = [$1] }
    | group PLUS name		{ $1.push( $3 ); $$ = $1 }
    | group MINUS name		{ $1.push( "~" + $3 ); $$ = $1; inversions.push( $3 ) }
    ;

scale :
   name TIMES factor		{ $$ = [ null, "scale", [ $1 ], $3 ] }
   ;

filter :
   name DIV PHRASE		{ $$ = [ null, "filter", [ $1 ], unwrap( $3 ) ] }
   ;

factor : NUMBER
   ;

leaf :
    NUMBER			
    ;

contracts :
    contract                    { $$ = [ $1 ] }
    | contracts contract	{ $1.push( $2 ); $$ = $1 }
    ;

contract :
    CONTRACT  declaration-part cover-part { $$ = [ $2.name, 'contract', [ $2.subject ], [ $3, $2.description ] ] }
    ;

declaration-part :
    DECLARATIONS declarations			{ $$ = under.object( $2 ) }
    ;

declarations :
    declaration					{ $$ = [ $1 ] }
    | declarations declaration 		       	{ $1.push( $2 ); $$ = $1 }
    ;

declaration :
    name IS name				{ $$ = [$1, $3] }
    ;

cover-part :
    COVERS cover				{ $$ = $2 }
    ;

cover :
    NUMBER PERCENT SHARE OF NUMBER XS NUMBER    { 
    	   $$ = ['' + $1 + $2, $3, $4, $5,$6,$7].join(' ') }
    ;

