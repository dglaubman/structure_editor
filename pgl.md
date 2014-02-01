Position Language (PL)
================
> Version 2. 1/30/2014

Position
--------

A (loss) Position represents a named collection of losses, and an operation which writes to this collection. There are six types of positions, corresponding to the following operations:

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

Grammar
-------

	    structure := STRUCTURE name positions contracts
		positions :=  POSITIONS position-list
		position-list := position | positions position  
		position := name IS position-expression  
		position-expression := grouping | scale | filter | leaf  

	    group := group PLUS group | group MINUS group | name  
		scale := scalar TIMES name  
		filter := name DIV criteria  
		leaf := URI | AMOUNT  
		contracts := contract | contracts contract  
		contract := CONTRACT cdl  


Examples
--------


> // A set of positions

	    STRUCTURE MarketTreaty

	        POSITIONS
				Acme:Book is /assets/10003
				Market:TreatyA.Placed is 40% of Market:TreatyA
				Acme:Book net of Market:TreatyA.Placed is Acme:Book - Market:TreatyA.Placed
			
			CONTRACT
				DECLARATIONS
				    Name is Market:TreatyA
					Subject is Acme:Book
					Attachment Basis is Risk Attaching
				COVERS
					100% Share of 10M xs 1M


> // A contract, and its two positions

	    Contract
			Declarations
				Name is My:Cat1
				Subject is Acme:Book net of Market:TreatyA.Placed
			Covers
				100% Share of 10M xs 10M


> // A filter position

	     
		 Acme:Book.Comm is Acme:Book / LOB is commercial

> // A branch position

	     POSITIONS
			 My:Assumed is
				 if red then My:Cat1.Written
				 if blue then My:Cat1.Signed


> or

	     POSITIONS
			 My:Assumed is
				 red  ?  My:Cat1.Written
				 blue ? My:Cat1.Signed


Position Graph
--------------


    GET /structure/103

	structure imported_wx

    positions
        Acme:Net is Acme:Gross - Acme:Ceded
    	Acme:Gross is Acme:Direct + Acme:Assumed
	    Acme:Direct is Acme:PortA
        Acme:Ceded is Acme:Fac + Acme:PerRisk + Acme:Cat
        Acme:PerRisk is Acme:Wx1.Placed
        Acme:Wx1.Placed is 0.4 * Market:WX1
        Our:Net is Our:Gross - Our:Ceded
        Our:Gross is Our:Direct + Our:Assumed
        Our:Assumed is Our:WX1.Signed
        Our:Ceded is Our:WX1.Ceded
        Our:WX1.Ceded is 0.5 * Our:WX1.Signed 
        Our:WX1.Signed is 0.07 * Market:WX1

        contract
	    declarations
	       name is Market:WX1
	       subject is Acme:PortA
	    covers
	       100% of 10M xs 10M	

