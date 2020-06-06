// 32X32 Iterative Multiplier template
module mult32x32 (
    input logic clk,            // Clock
    input logic reset,          // Reset
    input logic start,          // Start signal
    input logic [31:0] a,       // Input a
    input logic [31:0] b,       // Input b
    output logic busy,          // Multiplier busy indication
    output logic [63:0] product // Miltiplication product
);

// Put your code here
// ------------------

// FSM synchronous procedural block.
    always_ff @(posedge clk, posedge rst) begin
        if (rst == 1'b1) begin
            current_state <= idle_st;
        end
        else begin
            current_state <= next_state;
        end
    end


// End of your code

endmodule
