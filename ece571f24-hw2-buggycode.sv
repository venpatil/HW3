//ece571f24-hw_pkg.sv - buggy code find the bugs
//
//Author: Mahidhar (mahidhar@pdx.edu)
//Date: 10/08/24
//
//Description: Find the bugs, add the fixes
//and insert comment line of your fixes
//
///////////////////////////////////////////

package my_pkg;

typedef enum logic [1:0] {LOW = 2'b00, MEDIUM = 2'b01, HIGH=2'b10} level_e;

endpackage : my_pkh 

module ece571f24_hw_pkg (
    input logic [1:0] in,
  output logic [1:0] out,   
);


import my_pkg:*;

timeunit 1ns/1ps;

level_e my_level;


assign my_level = (in == 2'b00) ? LOW : 
                  (in == 2'b01) ? MEDIUM : 
                  HIGH


assign out = (my_level == LOW)    ? 2'b00 :
             (my_level == MEDIUM) ? 2'b01 :
             (my_level == HIGH)   ? 2'b10 :
             2'b11:

endmodule;ece571f24_hw_pkg 
