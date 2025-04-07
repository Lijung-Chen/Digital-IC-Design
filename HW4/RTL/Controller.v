module Controller(
    input               clk,
    input               rst,
    input               data_valid,
    input               cmd_valid,
    input       [2:0]   cmd,
    input       [7:0]   index,
    input       [7:0]   value,
    input               finish_0,   //Build_Queue(0)
    input               finish_1,   //Extract_Max(1)
    input               finish_2,   //Increase_Value(2)
    input               finish_3,   //Insert_Data(3)
    input               done,       //write(4)
    output              busy,
    output      [2:0]   active_mode,
    output              data_wen,
    output              heap_size_rst,
    output  reg [7:0]   current_index, 
    output  reg [7:0]   current_value
);

parameter   IDLE = 2'd0,
            INPUT_DATA  = 2'd1,
            INPUT_CMD = 2'd2,
            EXCUTE = 2'd3;

reg [1:0]   state, next_state;
reg [2:0]   current_cmd;
wire    finish;

assign  busy = (state != INPUT_CMD);
assign  finish = (finish_0 || finish_1 || finish_2 || finish_3);
assign  active_mode = (state == EXCUTE)? current_cmd : 3'd5;    //mode5 : no module active
//assign  data_wen = (state == INPUT_DATA && data_valid) || (state == IDLE && data_valid);
assign  data_wen = data_valid;
assign  heap_size_rst = (state == IDLE) && (~data_valid);


//===========================FSM============================
always @(posedge clk or posedge rst) begin
    if(rst) state <= IDLE;
    else    state <= next_state;
end

always@(*)
case(state)
    IDLE:       next_state = (data_valid)? INPUT_DATA : IDLE;
    INPUT_DATA: next_state = (~data_valid)? INPUT_CMD : INPUT_DATA;
    INPUT_CMD:  next_state = (cmd_valid)? EXCUTE : INPUT_CMD;
    default:    next_state = (done)? IDLE : (finish)? INPUT_CMD : EXCUTE;
endcase


//===========================CMD Related============================
always @(posedge clk or posedge rst) begin
    if(rst) begin
        current_cmd <= 3'd5;
        current_index <= 8'd0;
        current_value <= 8'd0;
    end
    else if(cmd_valid & ~busy)    begin
        current_cmd <= cmd;
        current_index <= index;
        current_value <= value;
    end
    else begin
        current_cmd <= current_cmd;
        current_index <= current_index;
        current_value <= current_value;
    end
end


endmodule
