// 32X32 Multiplier FSM
module mult32x32_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    output logic busy,            // Multiplier busy indication
    output logic [1:0] a_sel,     // Select one byte from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [2:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

// Put your code here
// ------------------

typedef enum { idle_st, a1b1, a1b2, a2b1, a2b2, a3b1, a3b2, a4b1, a4b2 } states;
states current_state;
states next_state;

// FSM synchronous procedural block.
    always_ff @(posedge clk, posedge reset) begin
        if (reset == 1'b1) begin
            current_state <= idle_st;
        end
        else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        // Default assignments
        next_state = current_state;
        busy = 1'b1;
        a_sel = 2'b00;
        b_sel = 1'b0;
        shift_sel = 3'b000;
        upd_prod = 1'b1;
        clr_prod = 1'b0;

        case(current_state)
            idle_st: begin
                if (start == 1'b0) begin
                    busy = 1'b0;
                    upd_prod = 1'b0;
                    clr_prod = 1'b1;
                end else begin
                    busy = 1'b0;
                    next_state = a1b1;
                end
            end
            a1b1: begin
                b_sel = 1'b1;
                shift_sel = 3'b010;
                next_state = a1b2;
            end
            a1b2: begin
                a_sel = 2'b01;
                shift_sel = 3'b001;
                next_state = a2b1;
            end
            a2b1: begin
                a_sel = 2'b01;
                b_sel = 1'b1;
                shift_sel = 3'b011;
                next_state = a2b2;
            end
            a2b2: begin
                a_sel = 2'b10;
                shift_sel = 3'b010;
                next_state = a3b1;
            end
            a3b1: begin
                a_sel = 2'b10;
                b_sel = 1'b1;
                shift_sel = 3'b100;
                next_state = a3b2;
            end
            a3b2: begin
                a_sel = 2'b11;
                shift_sel = 3'b011;
                next_state = a4b1;
            end
            a4b1: begin
                a_sel = 2'b11;
                b_sel = 1'b1;
                shift_sel = 3'b101;
                next_state = a4b2;
            end
            a4b2: begin
                busy = 1'b0;
                upd_prod = 1'b0;
                clr_prod = 1'b1;
                next_state = idle_st;
            end
        endcase
    end

// End of your code

endmodule
