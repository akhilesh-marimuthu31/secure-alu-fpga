// top_alu_fpga.v
// Simple wrapper around top_alu_arty_s7.

module top_alu_fpga (
    input  wire        clk,
    input  wire [3:0]  sw,
    input  wire [3:0]  btn,
    output wire [3:0]  led
);

    top_alu_arty_s7 uut (
        .clk (clk),
        .sw  (sw),
        .btn (btn),
        .led (led)
    );

endmodule
