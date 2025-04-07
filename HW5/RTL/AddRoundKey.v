module AddRoundKey (
    input   [127:0] state_in,
    input   [127:0] key_in, //after keyexpansion
    output  [127:0] state_out
);
    
assign  state_out = state_in ^ key_in;

endmodule
