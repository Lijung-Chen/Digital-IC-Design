//P+K
module  Round10(
    input           clk,
    input           rst,
    input           valid_in,
    input   [3:0]   round_in,
    input   [127:0] state_in,
    input   [127:0] key_in,
    output  reg     valid_out,
    output  [127:0] state_out
);

wire    [127:0] state_array,
                state_subbyte,
                state_mixcol,
                key_array,
                sub_key;

wire    [3:0]   round;

reg     [127:0] state_reg;

//================Plaintext================
//ShiftRows
Reg128_P    reg_p(
    //input
    .clk        (clk),
    .rst        (rst),
    .valid_in   (valid_in),
    .P          (state_in),
    //output
    .valid_out  (valid_reg),
    .state_out  (state_array)
);

SubByte subbyte(
    .state_in   (state_array),
    .state_out  (state_subbyte)
);

//---------------pipeline---------------
always@(posedge clk)begin
    if(rst) begin
        state_reg <= 128'd0;
        valid_out <= 1'b0;
    end
    else    begin
        state_reg <= state_subbyte;
        valid_out <= valid_reg;
    end
end

AddRoundKey addkey(
    .state_in   (state_reg),
    .key_in     (sub_key),      //after keyexpansion
    .state_out  (state_out)
);


//================Key================
Reg128_K    reg_k(
    //input
    .clk        (clk),
    .rst        (rst),
    .K          (key_in),
    .round_in   (round_in),
    //output
    .key_out    (key_array),
    .round_out  (round)
);

KeyExpansion    keyexp(
    .clk        (clk),
    .rst        (rst),
    .round      (round),        //9
    .key_in     (key_array),
    .key_out    (sub_key)
);
endmodule
