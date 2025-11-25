module top_alu_arty_s7(
    input  wire        clk,
    input  wire [3:0]  sw,
    input  wire [3:0]  btn,
    output reg  [3:0]  led
);

    reg  [7:0] A, B, key;
    reg  [3:0] opcode;
    wire [7:0] core_result;
    reg  [7:0] encrypted;

    always @(*) begin
        A   = {4'b0000, sw};  // lower nibble from switches
        B   = 8'h05;          // constant input B = 5
        key = 8'hA5;          // encryption key

        case (btn[1:0])
            2'b00: opcode = 4'b0000;  // ADD
            2'b01: opcode = 4'b0001;  // SUB
            2'b10: opcode = 4'b0100;  // MUL
            2'b11: opcode = 4'b1010;  // SHIFT LEFT
            default: opcode = 4'b0000;
        endcase
    end

    alu_8bit u_alu (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(core_result)
    );

    // Encryption selection
    always @(*) begin
        if(btn[2] == 1'b0)        // XOR ENCRYPTION
            encrypted = core_result ^ key;
        else                     // S-BOX ENCRYPTION
            encrypted = {4'h0, core_result[3:0] ^ 4'hC};  
    end

    always @(*) led = encrypted[3:0];

endmodule
