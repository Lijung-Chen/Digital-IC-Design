module  Reg128_K(
    input               clk,
    input               rst,
    input       [127:0] K,
    input       [3:0]   round_in,
    output      [127:0] key_out,
    output  reg [3:0]   round_out
);

reg [7:0] key [0:15];
reg [4:0] idx;
reg [7:0] idx_8;
//integer idx;

assign  key_out = {key[0], key[1], key[2], key[3],
                   key[4], key[5], key[6], key[7],
                   key[8], key[9], key[10], key[11],
                   key[12], key[13], key[14], key[15]};

always @(posedge clk) begin
    if(rst)begin
        round_out <= 4'd0;
        for(idx=0; idx<16; idx=idx+1)
            key[idx] <= 8'd0;
    end
    else    begin
        round_out <= round_in;
        for(idx=0; idx<16; idx=idx+1)begin
            idx_8 = idx << 3;
            //key[idx] <= K[(127-idx<<3):(120-idx<<3)];
            key[idx] <= K[(120-idx_8)+:8];
        end
    end
end

endmodule
