Positions API
================
> Version 3. 1/28/2014

Position
--------

A (loss) Position represents a named collection of losses, and an operation which writes to this collection.
There are six types of positions, corresponding to the following operations:

* Group -- groups the losses from one or more input positions.
* Invert -- inverts its input position.
* Scale -- multiplies each loss from its input position by a constant factor
* Contract -- applies a specified contract payout function to its subject (input) position.
* Filter -- applies a predicate function to its input position. Losses for which the predicate is true are written to the position.
* Branch -- chooses one of its two input positions, based on a criterion. One of the positions may be marked as the default.

Positions may be created, retrieved, modified, or deleted via the API.
(Note: Contract positions are managed indirectly thru Contracts API.)

A Position corresponds to a node in a directed acyclic graph, where the edges consist of arrows from the position to its input position(s).
Given a Position (or set of Positions), the API also supports retrieving the subgraph of dependent positions.


### Creation

### `POST /positions`

Creates a new position.

> **Input**: Name, Namespace, Operation are required. Most operations require exactly one input position. Scale and contract have operation specific param.   
> **Output**: A representation of  the newly created Position resource  
> **Validations**:  
>> Fully qualified name ("namespace:name") must be unique within tenant (else HTTP error 409).  
>> Input positions must exist, but may be of any type.  
>> Output position must not exist prior to the POST.  
>> Other validations differ by position type (see examples)  

#### Examples:

> **Creating a leaf position**  
> A leaf position is a group with no children.  
> As such, its source of loss is external to Position DB (for example, a CSE)  
> We can augment this resource with an external identifier of its source, if this proves useful.  
>  
> Request:  

	        POST /positions
		    {
				"Name": "Acme:Book",
			}


> Reply:  

           201 Created
		   Location: /positions/1

	       {
	           "Name": "Acme:Book",
	           "Op": "Group",
	           "Links":
			   [  {"href": "/positions/1", "rel": "self"} ]
		   }


> **Creating a scaled position**  
> Note: the scale factor is always positive. Invert a scaled position to multiply by a negative factor.  
>
> Request:  

	        POST /positions

	        {
				"Name": "Market:TreatyA.Placed",
				"Op": "Scale",
				"Factor": 0.4,
				"Subject": "Market:TreatyA"
			}


> Reply:  

           201 Created
		   Location: /positions/101

	       {
			   "Name": "Market:TreatyA.Placed",
	           "NS": "Market",
			   "Op": "Scale",
			   "Factor": 0.4,
	           "Links":
			   [   {"href": "/positions/101", "rel": "self"},
				   {"href": "/positions/100", "rel": "subject"},
			   ]
		   }


> **Creating an inverted position**  
> An inverted position by convention has the same name as its subject, prefaced with a tilde(~).  
>
> Request:  

	        POST /positions

	        {
				"Name": "Market:~TreatyA.Placed",
				"Op": "Invert",
				"Subject": "Market:TreatyA.Placed"
			}


> Reply:  

           201 Created
		   Location: /positions/102

	       {
			   "Name": "~TreatyA.Placed",
	           "NS": "Market",
	           "FQName": "~Market:TreatyA.Placed",
		       "Op": "Invert",
	           "Links":
				   {"href": "/positions/101", "rel": "subject"},              # this is the placed position  
				   {"href": "/positions/102", "rel": "self"},                 # this is the inverted placed position  
			   ]
		   }


> **Creating a group position**  
> Note: To create a net position, invert then group.  
>
> Request:  

	        POST /positions

	        {
				"Name": "Book net of Market:TreatyB.Placed",
				"NS":  "Acme",
				"Op": "Group",
				"Subject": ["Acme:Book", "~Market:TreatyB.Placed"]
			}


> Reply:  

           201 Created
		   Location: /positions/103

	       {
			   "Name": "Book net of Market:TreatyB.Placed",
	           "NS": "Acme",
			   "FQName": "Acme:Book net of Market:TreatyB.Placed",
			   "Op": "Group",
	           "Links":
			   [   {"href": "/positions/103", "rel": "self"},
				   {"href": "/positions/1", "rel": "subject"},
				   {"href": "/positions/102", "rel": "subject"}
			   ]
		   }


> **Creating a contract position**  
> Unlike other positions, contract positions are created/modified indirectly via the Contract API.  
> Thus, a POST to /contracts creates a Contract resource (with CDL and decls) and an Ouput Position resource (corresponding to Contract Name).  
>
> Request:  

	        POST /contracts

				 "Declarations
				     Name is My:Cat1
					 Subject is Acme:Book net of Market:Treaty.Placed
	              Covers
			         100% Share of 10M xs 10M"


> Reply:  

           201 Created
		   Location: /contracts/2

	       {
			   "Name": "Cat1",
	           "NS": "My",
			   "FQName": "My:Cat1"
	           "Links":
			   [   {"href": "/contracts/2", "rel": "self"},
				   {"href": "/contracts/2/declarations", "rel": "declarations"},
				   {"href": "/contracts/2/text", "rel": "cdl"},
				   {"href": "/positions/103", "rel": "subject"},				   
				   {"href": "/positions/104", "rel": "output"},
			   ]
		   }


> **Creating a filter position**  
> Note: predicate syntax should match standard usage on RMS(one).  
> Predicate places resolution requirements on its subject (TBD).  
>
> Request:  

	        POST /positions

	        {
				"Name": "Book.Comm",
				"NS":  "Acme",
				"Op": "Filter",
				"Predicate": "LOB is commercial",
				"Subject": ["Acme:Book"]
			}


> Reply:  

           201 Created
		   Location: /positions/105

	       {
			   "Name": "Book.Comm",
	           "NS": "Acme",
			   "FQName": "Acme:Book.Comm",
			   "Op": "Filter",
			   "Predicate": "LOB is commercial",
	           "Links":
			   [   {"href": "/positions/105", "rel": "self"},
				   {"href": "/positions/1", "rel": "subject"},
			   ]
		   }


> **Creating a branch position**  
> Unlike a filter, a branch operation only allows one choice through.  
> A branch could depend on a RAP setting or attributes of the actual subject loss.  
> Both input positions must exist when this method is called.  
>
> Request:  

	        POST /positions

	        {
				"Name": "Assumed",
				"NS":  "My",
				"Op": "Cat1",
				"Expression": "if status is quoted then my:cat1.written else my:cat1.signed"
				"Subject": ["My:Cat1.Signed", "My:Cat1.Written"]
			}


> Reply:  

           201 Created
		   Location: /positions/108

	       {
			   "Name": "Assumed,
	           "NS": "My",
			   "FQName": "My:Assumed",
			   "Op": "Branch",
			   "Expression": "if status is quoted then my:cat1.written else my:cat1.signed"
	           "Links":
			   [   {"href": "/positions/108", "rel": "self"},
				   {"href": "/positions/106", "rel": "subject, default"},
				   {"href": "/positions/107", "rel": "subject"}
			   ]
		   }


Position Graph
--------------

This is a read/only API and thus supports GET. A possible end-point is /positions/graph, also providing a search string which corresponds to one or more positions.  
The output is a list containing the transitive closure of the search results and their subject positions (possibly limited by a depth param).  

### `GET /positions/graph?search-str`  

#### Example


> ** Get the position graph starting from My:Cat1 **

> Request:  

	    GET /positions/graph/?fqname=my:cat1
	
> Reply:

		200 OK

		[   {
				"FQName": "My:Cat1",                                                 # the Contract's output position
				"Op": "Contract",
				"Links": [
					{ "href": "/positions/104", "rel": "self" },
					{ "href": "/positions/103", "rel": "subject" },
					{ "href": "/contracts/2", "rel": "contract" } ] },
		    {
				"FQName": "Acme:Book net of Market:TreatyA.Placed",                 # the Contract's subject position
				"Op": "Group",
				"Links: [
					{ "href": "/positions/103", "rel": "self" },
					{ "href": "/positions/1", "rel": "subject" },                   # Acme:Book
					{ "href": "/positions/102", "rel": "subject" } ] },             # ~Market:TreatyA.Placed

		   {
			    "FQName": "Acme:Book",                                              # the leaf
				"Op": "Group",
				"Links": [
					{ "href": "/positions/1", "rel": "self" } ] },
		   {
			    "FQName": "~Market:TreatyA.Placed",                                 # the inversion
                "Op": "Invert",
				"Links: [
					{ "href": "/positions/102", "rel": "self" },
					{ "href": "/positions/101", "rel": "subject" } ] },
		   {
			    "FQName": "Market:TreatyA.Placed",                                 # the scaling
                "Op": "Scale",
				"Factor": 0.4,
				"Links: [
					{ "href": "/positions/101", "rel": "self" },
					{ "href": "/positions/100", "rel": "subject" } ] },

		   {
			    "FQName": "Market:TreatyA",                                        # treaty (also on Acme:Book, but not shown in above examples)
                "Op": "Contract",
				"Links: [
					{ "href": "/positions/100", "rel": "self" },
					{ "href": "/contracts/1", "rel": "contract" }
					{ "href": "/positions/1", "rel": "subject" } ] }
		]

			
