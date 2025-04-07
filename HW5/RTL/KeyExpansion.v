module KeyExpansion (
    input   clk,
    input   rst,
    input   [3:0]   round,  //0-9
    input   [127:0] key_in,
    output  [127:0] key_out
);

wire [31:0] RotWord;
wire [31:0] SubWord;
wire [31:0] XorRcon;
reg  [7:0]  Rcon;
reg  [31:0] XorRcon_reg;
reg  [127:0]    key_in_reg;

//---------------RotWord---------------
assign  RotWord = {key_in[23:16],key_in[15:8],key_in[7:0],key_in[31:24]};

//---------------SubWord---------------
S_box S0(.byte_in(RotWord[7:0]), .byte_out(SubWord[7:0]));
S_box S1(.byte_in(RotWord[15:8]), .byte_out(SubWord[15:8]));
S_box S2(.byte_in(RotWord[23:16]), .byte_out(SubWord[23:16]));
S_box S3(.byte_in(RotWord[31:24]), .byte_out(SubWord[31:24]));

//---------------xor Rcon---------------
always@(*)
case(round)
    4'd0:   Rcon = 8'h01;
    4'd1:   Rcon = 8'h02;
    4'd2:   Rcon = 8'h04;
    4'd3:   Rcon = 8'h08;
    4'd4:   Rcon = 8'h10;
    4'd5:   Rcon = 8'h20;
    4'd6:   Rcon = 8'h40;
    4'd7:   Rcon = 8'h80;
    4'd8:   Rcon = 8'h1b;
    default:   Rcon = 8'h36;
endcase

assign  XorRcon = SubWord ^ {Rcon,24'h000000};

//---------------pipeline---------------
always@(posedge clk)begin
    if(rst) XorRcon_reg <= 32'd0;
    else    XorRcon_reg <= XorRcon;
end

always@(posedge clk)begin
    if(rst) key_in_reg <= 128'd0;
    else    key_in_reg <= key_in;
end

//---------------xor---------------
assign  key_out[127:96] = key_in_reg[127:96] ^ XorRcon_reg;
assign  key_out[95:64] = key_in_reg[95:64] ^ key_out[127:96];
assign  key_out[63:32] = key_in_reg[63:32] ^ key_out[95:64];
assign  key_out[31:0] = key_in_reg[31:0] ^ key_out[63:32];


    
endmodule

