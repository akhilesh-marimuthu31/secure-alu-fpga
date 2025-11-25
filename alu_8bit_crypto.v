//============================================================
// 8-bit ALU with ALWAYS-ON encryption
//
// Pipeline:
//   1) Compute plain ALU result from A, B, opcode
//   2) OTP-style XOR with 8-bit key  -> otp_out
//   3) Mini 8-bit block cipher (2-round S-box SPN) on otp_out
//   4) Output = encrypted cipher text
//============================================================

module alu_8bit_crypto (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire [3:0] opcode,
    input  wire [7:0] key,
    output wire [7:0] result_enc
);

    // --------------------------------------------------------
    // 1) ALU core: ALL operations
    // --------------------------------------------------------
    reg [7:0] result_plain;

    always @(*) begin
        case (opcode)
            4'b0000: result_plain = A + B;        // ADD
            4'b0001: result_plain = A - B;        // SUB
            4'b0010: result_plain = A & B;        // AND
            4'b0011: result_plain = A | B;        // OR
            4'b0100: result_plain = A ^ B;        // XOR
            4'b0101: result_plain = ~A;           // NOT A
            4'b0110: result_plain = A + 8'd1;     // INC
            4'b0111: result_plain = A - 8'd1;     // DEC
            4'b1000: result_plain = A << 1;       // LSHIFT
            4'b1001: result_plain = A >> 1;       // RSHIFT
            4'b1010: result_plain = A * B;        // MUL (low 8 bits used)
            4'b1100: result_plain = A;            // PASS A
            4'b1101: result_plain = B;            // PASS B
            default: result_plain = 8'h00;
        endcase
    end

    // --------------------------------------------------------
    // 2) OTP-style XOR (one-time-pad style)
    // --------------------------------------------------------
    wire [7:0] otp_out = result_plain ^ key;

    // --------------------------------------------------------
    // 3) Mini 8-bit block cipher on otp_out
    // --------------------------------------------------------
    wire [7:0] cipher_out;

    mini_block_cipher u_block (
        .data_in (otp_out),
        .key     (key),
        .data_out(cipher_out)
    );

    // --------------------------------------------------------
    // 4) Final ALWAYS encrypted output
    // --------------------------------------------------------
    assign result_enc = cipher_out;

endmodule


//============================================================
// Mini 8-bit Block Cipher (2-round SPN):
//   - Pre-whitening with k0
//   - Each round: S-box on nibbles + bit permutation + XOR round key
//   - Round keys derived from 'key' in a simple (toy) way
//============================================================
module mini_block_cipher (
    input  wire [7:0] data_in,
    input  wire [7:0] key,
    output wire [7:0] data_out
);

    // Toy round keys (for educational use only)
    wire [7:0] k0 = key;
    wire [7:0] k1 = {key[3:0], key[7:4]};  // rotate nibbles
    wire [7:0] k2 = key ^ 8'h3C;           // XOR with constant

    //------------------ Local functions ----------------------
    // 4-bit S-box
    function [3:0] sbox4;
        input [3:0] in;
        begin
            case (in)
                4'h0: sbox4 = 4'hC;
                4'h1: sbox4 = 4'h5;
                4'h2: sbox4 = 4'h6;
                4'h3: sbox4 = 4'hB;
                4'h4: sbox4 = 4'h9;
                4'h5: sbox4 = 4'h0;
                4'h6: sbox4 = 4'hA;
                4'h7: sbox4 = 4'hD;
                4'h8: sbox4 = 4'h3;
                4'h9: sbox4 = 4'hE;
                4'hA: sbox4 = 4'hF;
                4'hB: sbox4 = 4'h8;
                4'hC: sbox4 = 4'h4;
                4'hD: sbox4 = 4'h7;
                4'hE: sbox4 = 4'h1;
                4'hF: sbox4 = 4'h2;
                default: sbox4 = 4'h0;
            endcase
        end
    endfunction

    // 8-bit S-box: apply 4-bit S-box to each nibble
    function [7:0] sbox8;
        input [7:0] in;
        reg   [3:0] hi, lo;
        begin
            hi = in[7:4];
            lo = in[3:0];
            sbox8 = {sbox4(hi), sbox4(lo)};
        end
    endfunction

    // Simple 8-bit bit permutation (for diffusion)
    function [7:0] perm8;
        input [7:0] in;
        begin
            // Example pattern, just to shuffle bits
            perm8[7] = in[0];
            perm8[6] = in[2];
            perm8[5] = in[4];
            perm8[4] = in[6];
            perm8[3] = in[1];
            perm8[2] = in[3];
            perm8[1] = in[5];
            perm8[0] = in[7];
        end
    endfunction
    //---------------------------------------------------------

    // Pre-whitening
    wire [7:0] st0 = data_in ^ k0;

    // Round 1: S-box ? permutation ? XOR k1
    wire [7:0] st1_s = sbox8(st0);
    wire [7:0] st1_p = perm8(st1_s);
    wire [7:0] st1   = st1_p ^ k1;

    // Round 2: S-box ? permutation ? XOR k2
    wire [7:0] st2_s = sbox8(st1);
    wire [7:0] st2_p = perm8(st2_s);
    wire [7:0] st2   = st2_p ^ k2;

    assign data_out = st2;

endmodule
