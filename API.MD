# Position API

  A Position is a named loss bucket.
  All positions have the following fields:

* name
* ns
* op - One of the following operations: scale, invert, group, group, filter, xform, xref or choose.
* links - collection of references to dependent positions
  * scale, invert, filter and xform take their loss from a single item
  * group and choose take their loss from one or more dependent items or rel type 'item'
  * xref takes its loss from an external source, of rel type 'xref'
* self - href to this position


## GET /positions/{id}
   Returns current version of Position by id

   There are seven types of Position, distinguished by the value of the 'op' field.


      
### Scaling position

    position: {
      name: 'exampleName'
      ns: 'exampleNamespace'
      desc: 'scales loss of item at links.href by scale.factor, which is a positive number'
      op: 'scale'
      scale: { factor: 0.3 }
      self: /positions/{id}
      links: {
        [ { href: '/positions/{srcid}', rel: 'item' } ]
      }
    }

### Inverting position

    position: {
      name: 'exampleName'
      ns: 'exampleNamespace'
      desc: 'inverts loss of item at links.href (ie, it scales by -1)'
      op: 'invert'
      self: /positions/{id}
      links: {
        [ { href: '/positions/{srcid}', rel: 'item'  } ]
      }
    }

### Grouping position

    position: {
      name: 'exampleName'
      ns: 'exampleNamespace'
      desc: 'groups loss of all items at links.href'
      op: 'group'
      self: /positions/{id}
      links: {
         [ { href: '/positions/{src1}', rel: 'item'},
	   { href: '/positions/{src2}', rel: 'item'},
	   ... 
	 ]
    }

### Filtering position

    position: {
      name: 'exampleName'
      ns: 'exampleNamespace'
      desc: 'filter loss of item at links.href'
      op: 'filter'
      filter: { criteria: [ "list of criteria. May be href in links to filter description?" ] }
      self: /positions/{id}
      links: {
         [ { href: '/positions/{src1}', rel: 'item'} ]
      }
    }

### Transforming position (contract)

    position: {
      name: 'exampleName'
      ns: 'exampleNamespace'
      desc: 'transform loss of item at links.href using instructions found in 'related' link (typically a contract)'
      op: 'xform'
      self: /positions/{id}
      links: {
         [ { href: '/positions/{src1}', rel: 'item'},
	   { href: '/contracts/{contractid}, rel: 'related' ]
      }
    }

### External position

    position: {
      name: 'exampleName'
      ns: 'exampleNamespace'
      desc: 'A leaf of position graph. Item points to a loss source outside of /positions graph'
      op: 'xref'
      self: /positions/{id}
      links: {
         [ { href: '/assets/{assetid}', rel: 'xref'},
      }
    }

### Choice position

    position: {
      name: 'exampleName'
      ns: 'exampleNamespace'
      desc: 'A branching node of position graph. Item
      op: 'choose'
      self: /positions/{id}
      links: {
         [ { href: '/positions/{choice1id}', rel: 'item', tags: 'green, default' },
	   { href: '/positions/{choice2id}', rel: 'item', tags: 'red' },
	   ...
	 ]
      }
    }

## POST /positions

###   post /positions/scale
   	{ name: 'aname(will_be_generated_is_not_supplied)'
	  ns: 'a_namespace'
	  factor: 0.3
	  links: [ href: '/positions/{srcPos}, rel: 'item' ] 
        }

###   post /positions/invert
   	{ name: 'aname(will_be_generated_is_not_supplied)'
	  ns: 'a_namespace'
	  links: [ href: '/positions/{srcPos}, rel: 'item' ] 
        }

###   post /positions/group
   	{ name: 'aname(will_be_generated_if_not_supplied)'
	  ns: 'a_namespace'
	  links: [ href: '/positions/{srcPos}, rel: 'item',
	  	   href: '/positions/{srcPos2}, rel: 'item' ] ... ] 
        }

###   post /positions/filter
   	{ name: 'aname(will_be_generated_if_not_supplied)'
	  ns: 'a_namespace'
	  criteria: { COB: 'Commerial' }
	  links: [ href: '/positions/{srcPos}, rel: 'item' ]
        }

###   post /contracts
   	"contract
	   declarations
             ns is acme
             name is 1x10PR
	     subject is acme:port1
	     risk is each contract
           covers
             100% share of 10M x 1M per risk"

#### <- 201 Created.  Location /contracts/{id}

     contract: {
       self: '/contracts/101'
       output: '/positions/1002'          // this pos of type 'xform' was created by the post to contracts
       subject: '/positions/1001'         // this pos of any type must exist before the post to contracts
       cdl: '/contracts/101/cdl'
     }

## GET /positions/graph/{rootIds}

	