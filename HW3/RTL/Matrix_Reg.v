module  Matrix_Reg(
    input           clk,
    input           rst,
    input           write_idx_rst,  //busy
    input           wen,
    input   [3:0]   read_idx,
    input   [7:0]   write_data,
    output  [7:0]   read_data
);

reg [7:0] register [0:8];
integer i;
reg [3:0] write_idx;

assign  read_data = register[read_idx];

always @(posedge clk or posedge rst) begin
    if(rst) 
        for(i=0; i<9; i=i+1)
            register[i] <= 8'd0;
    else if(wen)  
        register[write_idx] <= write_data;
    else
        register[write_idx] <= register[write_idx];
end


always @(posedge clk or posedge rst) begin
    if(rst) write_idx <= 4'd0;
    else if(write_idx_rst)  write_idx <= 4'd0;
    else    write_idx <= (wen)? (write_idx + 4'd1) : write_idx;
end

endmodule