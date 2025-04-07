// 
// Designer: N26120113 
//
module AES(
    input clk,
    input rst,
    input [127:0] P,
    input [127:0] K,
    output  [127:0] C,
    output  valid
    );

wire    [127:0] state_0, state_1, state_2, state_3,
                state_4, state_5, state_6, state_7,
                state_8, state_9,
                subkey_1, subkey_2, subkey_3, subkey_4,
                subkey_5, subkey_6, subkey_7, subkey_8,
                subkey_9;

wire    [3:0]   round_1, round_2, round_3, round_4,
                round_5, round_6, round_7, round_8,
                round_9;
reg valid_0;

AddRoundKey addkey(
    .state_in   (P),
    .key_in     (K),      //after keyexpansion
    .state_out  (state_0)
);

always @(posedge clk) begin
    if(rst) valid_0 <= 1'b0;
    else    valid_0 <= 1'b1;
end

Round1_9    R1(
    //input
    .clk        (clk),
    .rst        (rst),
    .valid_in   (valid_0),
    .round_in   (4'd0),
    .state_in   (state_0),
    .key_in     (K),
    //output
    .valid_out  (valid_1),
    .round_out  (round_1),
    .state_out  (state_1),
    .sub_key    (subkey_1)
);

Round1_9    R2(
    //input
    .clk        (clk),
    .rst        (rst),
    .valid_in   (valid_1),
    .round_in   (round_1),
    .state_in   (state_1),
    .key_in     (subkey_1),
    //output
    .valid_out  (valid_2),
    .round_out  (round_2),
    .state_out  (state_2),
    .sub_key    (subkey_2)
);

Round1_9    R3(
    //input
    .clk        (clk),
    .rst        (rst),
    .valid_in   (valid_2),
    .round_in   (round_2),
    .state_in   (state_2),
    .key_in     (subkey_2),
    //output
    .valid_out  (valid_3),
    .round_out  (round_3),
    .state_out  (state_3),
    .sub_key    (subkey_3)
);

Round1_9    R4(
    //input
    .clk        (clk),
    .rst        (rst),
    .valid_in   (valid_3),
    .round_in   (round_3),
    .state_in   (state_3),
    .key_in     (subkey_3),
    //output
    .valid_out  (valid_4),
    .round_out  (round_4),
    .state_out  (state_4),
    .sub_key    (subkey_4)
);

Round1_9    R5(
    //input
    .clk        (clk),
    .rst        (rst),
    .valid_in   (valid_4),
    .round_in   (round_4),
    .state_in   (state_4),
    .key_in     (subkey_4),
    //output
    .valid_out  (valid_5),
    .round_out  (round_5),
    .state_out  (state_5),
    .sub_key    (subkey_5)
);

Round1_9    R6(
    //input
    .clk        (clk),
    .rst        (rst),
    .valid_in   (valid_5),
    .round_in   (round_5),
    .state_in   (state_5),
    .key_in     (subkey_5),
    //output
    .valid_out  (valid_6),
    .round_out  (round_6),
    .state_out  (state_6),
    .sub_key    (subkey_6)
);

Round1_9    R7(
    //input
    .clk        (clk),
    .rst        (rst),
    .valid_in   (valid_6),
    .round_in   (round_6),
    .state_in   (state_6),
    .key_in     (subkey_6),
    //output
    .valid_out  (valid_7),
    .round_out  (round_7),
    .state_out  (state_7),
    .sub_key    (subkey_7)
);

Round1_9    R8(
    //input
    .clk        (clk),
    .rst        (rst),
    .valid_in   (valid_7),
    .round_in   (round_7),
    .state_in   (state_7),
    .key_in     (subkey_7),
    //output
    .valid_out  (valid_8),
    .round_out  (round_8),
    .state_out  (state_8),
    .sub_key    (subkey_8)
);

Round1_9    R9(
    //input
    .clk        (clk),
    .rst        (rst),
    .valid_in   (valid_8),
    .round_in   (round_8),
    .state_in   (state_8),
    .key_in     (subkey_8),
    //output
    .valid_out  (valid_9),
    .round_out  (round_9),
    .state_out  (state_9),
    .sub_key    (subkey_9)
);

Round10 R10(
    //input
    .clk        (clk),
    .rst        (rst),
    .valid_in   (valid_9),
    .round_in   (round_9),
    .state_in   (state_9),
    .key_in     (subkey_9),
    //output
    .valid_out  (valid),
    .state_out  (C)
);
endmodule