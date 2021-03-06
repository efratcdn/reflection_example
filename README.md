# reflection_example
* Title       : Cover the edges  
* Version     : 1.0
* Requires    : Specman {15.20...}
* Modified    : July 2018
* Description :

[ More e code examples in https://github.com/efratcdn/spmn-e-utils ]


The purpose of this utility is two folded - 

1) Demonstrating reflection
2) Demonstrating "playing with soft select" and its effect on coverage

This utility adds constraints aiming to cover the edge values of fields. 
With numeric fields and uniform distribution, the chance that the edge 
values (e.g. - MIN_INT and MAX_INT) will be generated randomly is very low.

For covering the edge values, people can add soft select constraints - 

    keep soft address == select {
        50 : edges;
        50 : others;
    };
  

The utility implemented in cover_edges.e creates such soft constraints 
automatically. It goes over user defined structs, and for fields whose 
range is very big - it adds constraints. The constraints are written to 
an e file, that should be loaded to the environment.


Usage:

 -- base line
 specman -c 'load cover_edges_usage_example.e; test; show cover sys.cover_trans'

 -- create the file with the soft constraints
 specman -c 'load  cover_edges.e; load cover_edges_usage_example.e; sys.add_edge_constraints(200)'

  
 -- run with the created file, with the additional constraints
 specman -c 'load cover_edges_usage_example.e; load edge_constraints; test; show cover sys.cover_trans'



Enhancements:

  This is a basic implementation of the "cover the edges" idea, and the code 
  can be improved in various ways.
 
  Some examples - 
    
       - Use DAC macro, instead of writing the constraints into a file that
         has to be loaded
       - Add constraints only for types defined in specific package/s
       - Ignore some types/fields
       - Implement different reasoning of "which fields to add soft
         constraints on"
       - ...
       
