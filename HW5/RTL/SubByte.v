module  SubByte(
    input   [127:0] state_in,
    output  [127:0] state_out
);

reg  [7:0] i;

S_box   s1(.byte_in(state_in[127:120]), .byte_out(state_out[127:120]));
S_box   s2(.byte_in(state_in[119:112]), .byte_out(state_out[119:112]));
S_box   s3(.byte_in(state_in[111:104]), .byte_out(state_out[111:104]));
S_box   s4(.byte_in(state_in[103:96]), .byte_out(state_out[103:96]));

S_box   s5(.byte_in(state_in[95:88]), .byte_out(state_out[95:88]));
S_box   s6(.byte_in(state_in[87:80]), .byte_out(state_out[87:80]));
S_box   s7(.byte_in(state_in[79:72]), .byte_out(state_out[79:72]));
S_box   s8(.byte_in(state_in[71:64]), .byte_out(state_out[71:64]));

S_box   s9(.byte_in(state_in[63:56]), .byte_out(state_out[63:56]));
S_box   s10(.byte_in(state_in[55:48]), .byte_out(state_out[55:48]));
S_box   s11(.byte_in(state_in[47:40]), .byte_out(state_out[47:40]));
S_box   s12(.byte_in(state_in[39:32]), .byte_out(state_out[39:32]));

S_box   s13(.byte_in(state_in[31:24]), .byte_out(state_out[31:24]));
S_box   s14(.byte_in(state_in[23:16]), .byte_out(state_out[23:16]));
S_box   s15(.byte_in(state_in[15:8]), .byte_out(state_out[15:8]));
S_box   s16(.byte_in(state_in[7:0]), .byte_out(state_out[7:0]));


endmodule
