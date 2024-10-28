////////////////////////////////////////////////
// Simple testbench to verify the CPU operations
// ece571_cpu_tb.sv
// No use of regfile initialziation in this one
// To be used with ECE571 labs
// Venkatesh Patil (venpatil@pdx.edu)
// Modify as needed
///////////////////////////////////////////////

module ece571_cpu_tb;

  // Parameters
  logic [31:0] a, b;
  ece571_cpu_pkg::opcode_t opcode;
  logic [31:0] result;

  // Expected result for self-checking
  logic [31:0] expected_result;

  // Instantiate the ece571 alu
  ece571_alu alu_inst (
    .opcode(opcode),
    .a(a),
    .b(b),
    .result(result)
  );

  // Task to apply test and check result
  task check_operation(
    ece571_cpu_pkg::opcode_t test_opcode,
    logic [31:0] operand_a,
    logic [31:0] operand_b,
    logic [31:0] exp_result
  );
    begin
      // Apply inputs
      opcode = test_opcode;
      a = operand_a;
      b = operand_b;
      expected_result = exp_result;

      // Wait for combinational logic to settle
      #1;

      // Display values for debugging and result verification
      $display("Opcode: %0d | A: %0d | B: %0d | Expected Result: %0d | Actual Result: %0d", opcode, a, b, expected_result, result);

      // Check if the output matches the expected result
      if (result !== expected_result) begin
        $fatal("Test failed for opcode %0d: A=%0d, B=%0d. Expected=%0d, Got=%0d", opcode, a, b, expected_result, result);
      end else begin
        $display("Test passed for opcode %0d: A=%0d, B=%0d. Result=%0d", opcode, a, b, result);
      end
    end
  endtask

  // Stimulus Block
  initial begin
    // Basic addition cases
    check_operation(ece571_cpu_pkg::OP_ADD, 32'd11, 32'd14, 32'd25);       // 10 + 20 = 30
    check_operation(ece571_cpu_pkg::OP_ADD, 32'd0, 32'd14, 32'd14);      // 0 + 100 = 100
    check_operation(ece571_cpu_pkg::OP_ADD, 32'd5, 32'd4, 32'd9);   // Max + 1 = Overflow check

    // Basic subtraction cases
    check_operation(ece571_cpu_pkg::OP_SUB, 32'd30, 32'd10, 32'd20);       // 30 - 10 = 20
    check_operation(ece571_cpu_pkg::OP_SUB, 32'd10, 32'd30, 32'hFFFFFFEC); // 10 - 30 = -20 (two's complement)
    check_operation(ece571_cpu_pkg::OP_SUB, 32'd0, 32'd0, 32'd0);          // 0 - 0 = 0

    // Bitwise AND cases
    check_operation(ece571_cpu_pkg::OP_AND, 32'hFF00FF00, 32'h0F0F0F0F, 32'h0F000F00); // Masking check
    check_operation(ece571_cpu_pkg::OP_AND, 32'hFFFFFFFF, 32'h0, 32'h0);               // All bits set & zero = zero
    check_operation(ece571_cpu_pkg::OP_AND, 32'hAAAAAAAA, 32'h55555555, 32'h0);        // Alternating bits

    // Bitwise OR cases
    check_operation(ece571_cpu_pkg::OP_OR, 32'hFF00FF00, 32'h0F0F0F0F, 32'hFF0FFF0F);  // Combine high and low bytes
    check_operation(ece571_cpu_pkg::OP_OR, 32'hFFFFFFFF, 32'h0, 32'hFFFFFFFF);         // All bits set OR zero = all bits set
    check_operation(ece571_cpu_pkg::OP_OR, 32'hAAAAAAAA, 32'h55555555, 32'hFFFFFFFF);  // Alternating bits = all bits set

    // Bitwise XOR cases
    check_operation(ece571_cpu_pkg::OP_XOR, 32'hFF00FF00, 32'h0F0F0F0F, 32'hF00FF00F); // XOR check
    check_operation(ece571_cpu_pkg::OP_XOR, 32'h0, 32'h0, 32'h0);                       // Zero XOR zero = zero
    check_operation(ece571_cpu_pkg::OP_XOR, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'h0);         // Max XOR Max = zero

    // End simulation
    $finish;
  end

endmodule

