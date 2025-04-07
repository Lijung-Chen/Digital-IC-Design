module MPQ(clk,rst,data_valid,data,cmd_valid,cmd,index,value,busy,RAM_valid,RAM_A,RAM_D,done);
input clk;
input rst;
input data_valid;
input [7:0] data;
input cmd_valid;
input [2:0] cmd;
input [7:0] index;
input [7:0] value;
output  busy;
output  RAM_valid;
output [7:0]RAM_A;
output  [7:0]RAM_D;
output  done;

wire    [2:0]   active_mode;
wire    [7:0]   current_index,
                current_value,
                read_data1,
                read_data2;
wire    [3:0]   heap_size,
                swap_idx1,
                swap_idx2,
                read_idx1,
                read_idx2,
                left_right,
                largest,
                root_i,
                parent,
                read_idx_IV,
                read_idx_WR,
                root_idx_MH;


assign  RAM_D = read_data1;
assign  RAM_A = {4'd0,read_idx_WR-4'd1};

Controller ctrl(
    //input
    .clk            (clk),
    .rst            (rst),
    .data_valid     (data_valid),
    .cmd_valid      (cmd_valid),
    .cmd            (cmd),
    .index          (index),
    .value          (value),
    .finish_0       (finish_0),   //Build_Queue(0)
    .finish_1       (finish_1),   //Extract_Max(1)
    .finish_2       (finish_2),   //Increase_Value(2)
    .finish_3       (finish_3),   //Insert_Data(3)
    .done           (done),       //write(4)
    //output
    .busy           (busy),
    .active_mode    (active_mode),
    .data_wen       (data_wen),
    .heap_size_rst  (heap_size_rst),
    .current_index  (current_index), 
    .current_value  (current_value)
);

Data_reg    data_reg(
    //input
    .clk            (clk),
    .rst            (rst),
    .active_mode    (active_mode),
    //input data
    .data_wen       (data_wen),
    .write_data     (data),
    //Max_Heapify / INCREASE_VALUE
    .swap           (swap),
    .swap_idx1      (swap_idx1),
    .swap_idx2      (swap_idx2),
    //INCREASE_VALUE
    .value_wen      (value_wen),
    .value_idx      (current_index),  //ctrl current index
    .value          (current_value),  //ctrl current value
    //heap size
    .heap_size_rst  (heap_size_rst),  //ctrl stste = IDLE
    .increase_size  (increase_size),  //INSERT_DATA
    .decrese_size   (decrese_size),   //EXTRACT_MAX
    //read index
    .read_idx1      (read_idx1),
    .read_idx2      (read_idx2),
    //output
    .heap_size      (heap_size),  //length
    .read_data1     (read_data1),
    .read_data2     (read_data2)
);

MUX mux(
    //input
    .active_mode    (active_mode),
    //-----------swap-------------
    //MH(0,1)
    .swap_MH        (swap_MH),
    .largest        (largest),        //swap_idx1 / read_idx2
    .root_idx_MH    (root_idx_MH),    //swap_idx2
    //IV,ID(2,3)
    .swap_IV        (swap_IV),
    .parent         (parent),         //swap_idx1 /read_idx1
    .read_idx_IV    (read_idx_IV),    //swap_idx2 /read_idx2
    //------------read-------------
    //MH(0,1)
    .left_right     (left_right),     //read_idx1
    //IV,ID(2,3)
    //WR(4)
    .read_idx_WR    (read_idx_WR),    //read_idx1

    //output
    //-----------swap-------------
    .swap           (swap),
    .swap_idx1      (swap_idx1),
    .swap_idx2      (swap_idx2),
    //------------read-------------
    .read_idx1      (read_idx1),
    .read_idx2      (read_idx2)
);

Max_Heapify MH(
    //input
    .clk            (clk),
    .rst            (rst),
    .active_MH      (active_MH),      //from build queue
    .decrese_size   (decrese_size),     //from extract max
    .heap_size      (heap_size),        //length
    .root_i         (root_i),             //from build queue / extract max (root=1)
    .left_right_data(read_data1),
    .largest_data   (read_data2),
    //output
    .swap           (swap_MH),
    .finish         (finish_MH),
    .left_right     (left_right),   //read_idx1
    .largest_out    (largest),      //read_idx2 /swap_idx1
    .root_idx_out   (root_idx_MH)   //swap_idx2
);

//mode 0
Build_Queue mode0(
    //input
    .clk            (clk),
    .rst            (rst),
    .active_mode    (active_mode),
    .heap_size      (heap_size),      //length
    .finish_MH      (finish_MH),
    //output
    .active_MH      (active_MH),
    .finish         (finish_0),
    .root_i         (root_i)
);

//mode 1
Extract_Max mode1(
    //input
    .clk            (clk),
    .rst            (rst),
    .active_mode    (active_mode),
    .heap_size      (heap_size),     //length
    .finish_MH      (finish_MH),
    //output
    .finish         (finish_1),
    .decrese_size   (decrese_size)
);

//mode 2
Increase_value  mode2(
    //input
    .clk            (clk),
    .rst            (rst),
    .active_mode    (active_mode),
    .active_IV      (active_IV),
    .value_idx      (current_index),  //ctrl current index
    .heap_size      (heap_size),    
    .data_index     (read_data2),
    .data_parent    (read_data1),
    //output
    .value_wen      (value_wen),
    .finish         (finish_2),
    .swap           (swap_IV),
    .parent         (parent),       //read_idx1 / swap_idx1
    .index          (read_idx_IV)   //read_idx2 / swap_idx2
);

//mode 3
Insert_Data mode3(
    //input
    .clk            (clk),
    .rst            (rst),
    .active_mode    (active_mode),
    .finish_IV      (finish_2),
    //output
    .increase_size  (increase_size),
    .active_IV      (active_IV),
    .finish         (finish_3)
);

//mode 4
Write_RAM   mode4(
    //input
    .clk            (clk),
    .rst            (rst),
    .active_mode    (active_mode),
    .heap_size      (heap_size),  //length
    //output
    .RAM_valid      (RAM_valid), 
    .done           (done),
    .read_idx       (read_idx_WR)    //for Data_reg read_idx1
);



endmodule