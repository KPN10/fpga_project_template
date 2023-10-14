module seven_segment (
    input logic [3:0] i_hex,
    input logic i_en,
    output logic [6:0] o_segment
);

logic [3:0] bcd;
assign bcd = i_hex;

logic [6:0] segment;
assign o_segment = i_en ? segment : '1;

always @(*)
    case(bcd)
    4'h0: segment = 7'b1000000;
    4'h1: segment = 7'b1111001;
    4'h2: segment = 7'b0100100;
    4'h3: segment = 7'b0110000;
    4'h4: segment = 7'b0011001;
    4'h5: segment = 7'b0010010;
    4'h6: segment = 7'b0000010;
    4'h7: segment = 7'b1111000;
    4'h8: segment = 7'b0000000;
    4'h9: segment = 7'b0011000;
    4'ha: segment = 7'b0001000;
    4'hb: segment = 7'b0000011;
    4'hc: segment = 7'b1000110;
    4'hd: segment = 7'b0100001;
    4'he: segment = 7'b0000110;
    4'hf: segment = 7'b0001110;
    default: segment = '1;
    endcase

endmodule
