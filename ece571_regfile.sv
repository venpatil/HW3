/////////////////////////////////////////////
// Register file definitions
// We may not use it for the initial labs
// Venkatesh Patil (venpatil@pdx.edu)
// ece571_reg_file.sv
////////////////////////////////////////////

module ece571_regfile (
  input logic clk,
  input logic [3:0] read_addr1,
  input logic [3:0] read_addr2,
  input logic [3:0] write_addr,
  input logic [31:0] write_data,
  input logic we,
  output logic [31:0] read_data1,
  output logic [31:0] read_data2
);


  logic [31:0] regs[15:0];
 // Task to initialize registers
  task init_reg(input logic [3:0] addr, input logic [31:0] value);
    regs[addr] = value;
  endtask

  always_ff @(posedge clk) begin
    if (we)
      regs[write_addr] <= write_data;
  end

  assign read_data1 = regs[read_addr1];
  assign read_data2 = regs[read_addr2];

endmodule

