module  Mul_Adder(
    input                       clk,
    input                       rst,
    input                       Mul_Adder_active,   //state = COMPUTE_MM (busy)
    input   [1:0]               M1_col_size,
    input   [1:0]               M2_col_size,
    input   signed  [7:0]       M1_data,
    input   signed  [7:0]       M2_data,
    output  reg [1:0]           M1_col_idx,
    output  reg [1:0]           M2_col_idx,
    output  reg [1:0]           M1_row_idx,
    output  [3:0]               M1_read_idx,
    output  [3:0]               M2_read_idx,
    output  reg signed  [19:0]  out_data
);

wire signed  [15:0]  mul_result;
wire [1:0] M2_row_idx;

assign  M1_read_idx = M1_col_size * M1_row_idx + M1_col_idx;
assign  M2_read_idx = M2_col_size * M2_row_idx + M2_col_idx;

assign  mul_result = M1_data * M2_data;

assign  M2_row_idx = M1_col_idx;

always @(posedge clk or posedge rst) begin
    if(rst) 
        M1_col_idx <= 2'd0;
    else if(~Mul_Adder_active)
         M1_col_idx <= 2'd0;
    else if(M1_col_idx == M1_col_size)  //M1 read col end / M2 read row end
        M1_col_idx <= 2'd0;
    else 
        M1_col_idx <= M1_col_idx + 2'd1;
end   

always @(posedge clk or posedge rst) begin
    if(rst) begin
        M2_col_idx <= 2'd0;
        M1_row_idx <= 2'd0;
    end
    else if(~Mul_Adder_active)  begin
        M2_col_idx <= 2'd0;
        M1_row_idx <= 2'd0;
    end
    else if(M1_col_idx == M1_col_size)  //M1 read col end / M2 read row end
        if(M2_col_idx == M2_col_size -1)   begin  //M2 read col end
            M2_col_idx <= 2'd0;
            M1_row_idx <= M1_row_idx + 2'd1;
        end
        else    begin
            M2_col_idx <= M2_col_idx + 2'd1; 
            M1_row_idx <=  M1_row_idx;
        end   
end


always @(posedge clk or posedge rst) begin
    if(rst) 
        out_data <= 20'd0;
    else if(~Mul_Adder_active | (M1_col_idx == M1_col_size))
        out_data <= 20'd0;
    else    
        out_data <= out_data + mul_result;
end

endmodule
