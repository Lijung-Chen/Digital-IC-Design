//mode = 2

module  Increase_value(
    input               clk,
    input               rst,
    input       [2:0]   active_mode,
    input               active_IV,      //from Insert Data
    input       [7:0]   value_idx,      //ctrl current index
    input       [3:0]   heap_size,
    input       [7:0]   data_index,
    input       [7:0]   data_parent,
    output              value_wen,
    output              finish,
    output              swap,
    output      [3:0]   parent,  //read_idx1 / swap_idx1
    output  reg [3:0]   index   //read_idx2 / swap_idx2
);

parameter   IDLE = 2'd0,
            SWAP = 2'd1,
            FINISH = 2'd2;

reg     [1:0]   state, next_state;

assign  parent = index >> 1;
assign  value_wen = (state == IDLE) && (active_mode == 3'd2 || active_IV);
assign  swap = (state == SWAP) && (index > 4'd1 && data_parent < data_index);
assign  finish = (state == FINISH);


//===========================FSM============================
always @(posedge clk or posedge rst) begin
    if(rst) state <= IDLE;
    else    state <= next_state;
end

always@(*)
case(state)
    IDLE:       next_state = (active_mode == 3'd2 || active_IV)? SWAP : IDLE;
    SWAP:       next_state = (index > 4'd1 && data_parent < data_index)? SWAP : FINISH;
    default:    next_state = IDLE;
endcase

//===========================Index============================
always @(posedge clk or posedge rst) begin
    if(rst)
        index <= 4'd0;
    else if(state == IDLE && active_mode == 3'd2)
        index <= value_idx[3:0];
    else if(active_IV)
        index <= heap_size - 4'd1;
    else if(swap)
        index <= parent;
    else 
        index <= index;
end

endmodule