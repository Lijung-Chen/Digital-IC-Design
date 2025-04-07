`define MATRIX_SIZE 16
`define MATRIX_SIZE_BITS 4

module  Data_reg(
    input               clk,
    input               rst,
    input       [2:0]   active_mode,
    //input data
    input               data_wen,
    input       [7:0]   write_data,
    //Max_Heapify / INCREASE_VALUE
    input               swap,
    input       [3:0]   swap_idx1,
    input       [3:0]   swap_idx2,
    //INCREASE_VALUE
    input               value_wen,
    input       [7:0]   value_idx,  //ctrl current index
    input       [7:0]   value,      //ctrl current value
    //heap size
    input               heap_size_rst,  //ctrl stste = IDLE
    input               increase_size,  //INSERT_DATA
    input               decrese_size,   //EXTRACT_MAX
    //read index
    input       [3:0]   read_idx1,
    input       [3:0]   read_idx2,

    output      [3:0]   heap_size,  //length
    output      [7:0]   read_data1,
    output      [7:0]   read_data2
);

integer i;

reg [7:0] register [0:`MATRIX_SIZE-1];
reg [`MATRIX_SIZE_BITS-1:0] write_idx;

// wire    [7:0]   data0, data1, data2, data3, data4, data5,
//                 data6, data7, data8, data9, data10, data11,
//                 data12, data13, data14, data15;

// assign  data0 = register[0];
// assign  data1 = register[1];
// assign  data2 = register[2];
// assign  data3 = register[3];
// assign  data4 = register[4];
// assign  data5 = register[5];
// assign  data6 = register[6];
// assign  data7 = register[7];
// assign  data8 = register[8];
// assign  data9 = register[9];
// assign  data10 = register[10];
// assign  data11 = register[11];
// assign  data12 = register[12];
// assign  data13 = register[13];
// assign  data14 = register[14];
// assign  data15 = register[15];

assign  read_data1 = register[read_idx1];
assign  read_data2 = register[read_idx2];
assign  heap_size = write_idx;

always @(posedge clk or posedge rst) begin
    if(rst) 
        for(i=0; i<`MATRIX_SIZE; i=i+1)
            register[i] <= 8'd255;

    else if(data_wen)  
        register[write_idx] <= write_data;

    else if(value_wen)
        if(active_mode == 3'd2)
            register[value_idx[3:0]] <= value;
        else
            register[heap_size - 4'd1] <= value;

    else if(swap)   begin
        register[swap_idx1] <= register[swap_idx2];
        register[swap_idx2] <= register[swap_idx1];
    end

    else if(increase_size)
        register[write_idx] <= 8'd0;

    else if(decrese_size)
        register[1] <= register[heap_size - 4'd1];

    else
        register[write_idx] <= register[write_idx];
end

always @(posedge clk or posedge rst) begin
    if(rst) 
        write_idx <= `MATRIX_SIZE_BITS'd1;
    else if(heap_size_rst)  
        write_idx <= `MATRIX_SIZE_BITS'd0;
    else if(increase_size | data_wen)  
        write_idx <= write_idx + `MATRIX_SIZE_BITS'd1;
    else if(decrese_size)   
        write_idx <= write_idx - `MATRIX_SIZE_BITS'd1;
    else    
        write_idx <= write_idx;
end


endmodule