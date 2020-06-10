// 32X32 Multiplier arithmetic unit template
module mult32x32_fast_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic [1:0] a_sel,     // Select one byte from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [2:0] shift_sel, // Select output from shifters
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic a_msb_is_0,     // Indicates MSB of operand A is 0
    output logic b_msw_is_0,     // Indicates MSW of operand B is 0
    output logic [63:0] product  // Miltiplication product
);

// Put your code here
// ------------------

logic [5:0] shift_amount;
logic [7:0] a_bits;
logic [15:0] b_bits;
logic [23:0] multiplier_result;
logic [63:0] shifted_result;
logic [63:0] addition_result;

always_comb begin
    // 4->1 mux to select correct a bits
    a_msb_is_0 = 1'b0;
    b_msw_is_0 = 1'b0;
    case(a_sel)
        2'b00: begin
            a_bits = a[7:0];
        end
        2'b01: begin
            a_bits = a[15:8];
        end
        2'b10: begin
            a_bits = a[23:16];
        end
        2'b11: begin
            a_bits = a[31:24];
        end
        default: break;
    endcase    
    
    // Checking state of a msb
    if (a[31:24] == 8'b00000000) begin
        a_msb_is_0 = 1'b1;
    end

    // Checking state of b msb
    if (b[31:16] == 16'b0000000000000000) begin
        b_msw_is_0 = 1'b1;
    end
	
    // 2->1 mux to select correct b bits
    case(b_sel)
        1'b0: begin
            b_bits = b[15:0];
        end
        1'b1: begin
            b_bits = b[31:16];
        end
        default: break;
    endcase    
    shift_amount = shift_sel * 8;

    // Saving the result of multiplication
    multiplier_result = a_bits * b_bits;
    // Shifting the result to the correct position
    shifted_result = multiplier_result << shift_amount;
    addition_result = product + shifted_result;
end

// // Saving the result of multiplication
// assign multiplier_result = a_bits * b_bits;
// // Shifting the result to the correct position
// assign shifted_result = multiplier_result << shift_amount;

// FSM synchronous procedural block.
// an FF is necessary to remember the current product result
// 64 bit adder for previous product and shifted result
    always_ff @(posedge clk, posedge reset) begin
        if (reset == 1'b1) begin
            product <= {64{1'b0}};
        end
        else begin
            if (clr_prod == 1'b1) begin
                product <= {64{1'b0}};
            end else if (upd_prod == 1'b1) begin
                // product <= product + shifted_result;
                product <= addition_result;
            end
        end
    end


// End of your code

endmodule
