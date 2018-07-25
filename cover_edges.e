
File name     : cover_edges.e
Title         : Cover edges
Project       : Utilities examples
Created       : 2018
              :
Description   : An small utility, showing how we can use the reflection to 
                get information about fields types, and how we can use this 
                information to improve the coverage.
  
                This utility adds constraints aiming to cover the edge values
                of fields. 
                With numeric fields and uniform distribution, the chance that
                the edge values (e.g. - MIN_INT and MAX_INT) will be generated
                randomly is very low.

                For covering the edge values, people can add soft select 
                constraints - 

                      keep soft address == select {
                          50 : edges;
                          50 : others;
                      };
  

                The utility implemented in this file creates such soft 
                constraints automatically. It goes over user defined structs,
                and for fields whose range is very big - it adds constraints.
                The constraints are written to an e file, that should be
                loaded to the environment.

 
  
Demo          : 
  
  -- base line
  -- running the environment as is
  specman -c 'load cover_edges_usage_example.e; test; show cover sys.cover_trans'

 -- create the file with the soft constraints
 specman -c 'load  cover_edges.e; load cover_edges_usage_example.e; sys.add_edge_constraints(200)'

  
 -- run with the created file, with the additional constraints
 specman -c 'load cover_edges_usage_example.e; load edge_constraints; test; show cover sys.cover_trans'


  
<'

extend sys {
     
    // add_edge_constraints()
    //
    // Go over all user structs in requested package, and look for
    // wide range fields
    //
    // can be improved: go only on structs of specific package/s
    
    
    add_edge_constraints(num_of_vals : int) is {
        var my_file : file = files.open("edge_constraints.e", 
                                        "w", "big fields");
        files.write(my_file, append("  This file is created automatically, ",
                                    "by the cover_edges utility"));
        files.write(my_file, append("<'"));
        
        // go over all user defined structs
        for each rf_struct (rs) in rf_manager.get_user_types() {
            find_wide_fields(rs, num_of_vals, my_file);
        };
        
        files.write(my_file, append("'>"));
        files.close(my_file);
    };
    
    
    // find_wide_fields()
    //
    // Find the fields that their type can have more than <num_of_vals> 
    // values.
    // With these fields, it is less likely that the edges will be covered 
    
    find_wide_fields(rs : rf_struct, num_of_vals : int, my_file : file ) is {
            
        var t : rf_type;  
            
        // go over all struct's fields
        for each (f) in rs.get_declared_fields() {
                
            if f.is_ungenerated()  {
                // ignore the non generatable fields
                continue;
            };
                
            t =  f.get_type();
                                   
            // for numeric fields: get their range size. 
              
            if t is a rf_numeric (nu) {
                if nu.get_set_of_values().size() > num_of_vals {
                    add_edge_constraint(rs, f, my_file);
                };
            };
        }; // for each field
    };


    // add_edge_constraint()
    //
    // Add a soft constraint selecting the edges, to the requested field in 
    // the requested struct
    
    // Can be improved: different file for different package, 
    //                  configurable weights 
    
    add_edge_constraint (s : rf_struct, f : rf_field, my_file : file) is {
        
          files.write(my_file, append("extend ", 
                                    s.get_name(), "{"));
        
          files.write(my_file, append("    keep soft ", f.get_name(),
                                               " == select {"));
          files.write(my_file, "        50 : edges;");
          files.write(my_file, "        50 : others;");
          files.write(my_file, "    };");
        
          files.write(my_file, "};");
        
    };

};



'>