module  Reg128_P(
    input               clk,
    input               rst,
    input               valid_in,
    input       [127:0] P,
    output  reg         valid_out,
    output      [127:0] state_out
);

reg [7:0] state [0:15];
reg [4:0] idx;
reg [4:0] r_8;
reg [1:0] c;
reg [7:0] c_32;
//integer idx,r,c;

assign  state_out = {state[0], state[1], state[2], state[3],
                     state[4], state[5], state[6], state[7],
                     state[8], state[9], state[10], state[11],
                     state[12], state[13], state[14], state[15]};

always @(posedge clk) begin
    if(rst) begin
        valid_out <= 1'b0;
        for(idx=0; idx<16; idx=idx+1)
            state[idx] <= 8'd0;
    end
    else    begin
        valid_out <= valid_in;
        for(idx=0; idx<16; idx=idx+1)  begin
            //Sr,c
            // r = idx[1:0] << 3;  //8r
            // c = (idx[1:0] + idx[3:2]) << 5;     //32c
            r_8 = idx[1:0] << 3;  //8r
            c = idx[1:0] + idx[3:2];     //32c
            c_32 = c << 5;
            //state[idx] <= P[(127-c-r):(120-c-r)];
            //state[idx] <= P[(120-c-r)+:8];
            state[idx] <= P[(120-c_32-r_8)+:8];
        end 
    end
end


endmodule
