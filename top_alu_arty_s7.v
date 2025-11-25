//============================================================
// Top module for Arty S7-50
// - A comes from switches SW3..SW0  (0..15)
// - B is constant 5
// - key = {4'b1010, SW3..SW0}  -> depends on user switches
// - btn[3:0] directly select ALU opcode (4-bit)
// - ALU result is ALWAYS encrypted:
//      result_plain -> XOR with key -> S-box block cipher
// - LEDs (LED2..LED5) show lower 4 bits of encrypted result
//============================================================

module top_alu_arty_s7 (
    input  wire        clk,    // not used in logic, but constrained
    input  wire [3:0]  sw,     // SW3..SW0 -> A and key low bits
    input  wire [3:0]  btn,    // BTN3..BTN0 -> opcode
    output reg  [3:0]  led     // mapped to LED2..LED5 on board
);

    // Operand and key setup
    wire [7:0] A   = {4'b0000, sw};   // A = 0..15
    wire [7:0] B   = 8'h05;           // B fixed = 5
    wire [7:0] key = {4'b1010, sw};   // key high nibble fixed, low nibble from switches

    wire [3:0] opcode = btn;          // opcode = BTN3..BTN0 directly

    wire [7:0] result_enc;            // final encrypted result

    // ALU + crypto block (ALWAYS encrypted)
    alu_8bit_crypto u_alu_crypto (
        .A         (A),
        .B         (B),
        .opcode    (opcode),
        .key       (key),
        .result_enc(result_enc)
    );

    // Drive LEDs with lower 4 bits of encrypted result
    always @(*) begin
        led = result_enc[3:0];
    end

endmodule
