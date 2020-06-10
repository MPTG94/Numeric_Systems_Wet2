// 32X32 Multiplier test template
module mult32x32_test;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Start signal
    logic [31:0] a;       // Input a
    logic [31:0] b;       // Input b
    logic busy;           // Multiplier busy indication
    logic [63:0] product; // Miltiplication product

// Put your code here
// ------------------

mult32x32 mult (
    .clk(clk),
    .reset(reset),
    .start(start),
    .a(a),
    .b(b),
    .busy(busy),
    .product(product)
);

initial begin
    clk = 1'b1;
    reset = 1'b1;
    start = 1'b0;

    // Wait for 4 clock cycles
    #40
    reset = 1'b0;
    a = 32'b00010011000000110100010111010010;
    b = 32'b00010010101100010011000001101001;

    // Waiting for 1 clock cycle before starting
    #10

    // Mark start at clock rise
    @(posedge clk) begin
        start = 1'b1;    
    end
    
    // Mark end at clock rise
    @(posedge clk) begin
        start = 1'b0;    
    end
end

always begin
    // Clock cycle is 10ns
    // 5 up
    // 5 down
    #5
    clk = ~clk;
end

// End of your code

endmodule
