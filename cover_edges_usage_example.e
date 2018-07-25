File name     : cover_edges_usage_example.e
Title         : Cover edges
Project       : Utilities examples
Created       : 2018
              :
Description   : This is used to demonstate the cover_edges.
  
  Running:
  
  
 -- base line
 specman -c 'load cover_edges_usage_example.e; test; show cover sys.cover_trans'

 -- create the file with the soft constraints
 specman -c 'load  cover_edges.e; load cover_edges_usage_example.e; sys.add_edge_constraints(200)'

  
 -- run with the created file, with the additional constraints
 specman -c 'load cover_edges_usage_example.e; load edge_constraints; test; show cover sys.cover_trans'



<'

type kind_t : [STATUS, CTRL, IDLE];
type data_t : uint (bits : 16);

struct transfer {
    address    : uint (bits : 16);
    kind       : kind_t;
    first_data : data_t;
    legal      : bool;
};


// check coverage:
// many random generations
extend sys {
    !cur_trans : transfer;
    
    event cover_trans;
    cover cover_trans is {
        item address    : uint (bits : 16) = cur_trans.address using ranges = {
            range([0..0x20], "small address");
            range([0x21..0xffdf], "", 4000, 10);
            range([0xffe0..0xffff], "high address");
        };
        item kind       : kind_t  = cur_trans.kind;
        item first_data : data_t  = cur_trans.first_data using ranges = {
            range([0..0x20], "small address");
            range([0x21..0xffdf], "", 4000, 10);
            range([0xffe0..0xffff], "high address");
        };;
        item legal      : bool             = cur_trans.legal;
    };
    
    scenario() @any is {
        raise_objection(TEST_DONE);
        for i from 0 to 40 {
            wait cycle;
            gen cur_trans;
            emit cover_trans;
        };
        
     
        drop_objection(TEST_DONE);
    };
    
    run() is also {
        start scenario();
    };
};
'>
