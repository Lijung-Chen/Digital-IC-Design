//mode = 3

module  Insert_Data(
    input               clk,
    input               rst,
    input       [2:0]   active_mode,
    input               finish_IV,
    output              increase_size,
    output              active_IV,
    output              finish
);

parameter   IDLE = 2'd0,
            WRITE_REG = 2'd1,
            INSERT = 2'd2;

reg [1:0]   state, next_state;

assign  increase_size = (state == IDLE) && (active_mode == 3'd3);
assign  active_IV = (state == WRITE_REG);
assign  finish = finish_IV && (state == INSERT);


//===========================FSM============================
always @(posedge clk or posedge rst) begin
    if(rst) state <= IDLE;
    else    state <= next_state;
end

always@(*)
case(state)
    IDLE:       next_state = (active_mode == 3'd3)? WRITE_REG : IDLE;
    WRITE_REG:  next_state = INSERT;
    default:    next_state = (finish_IV)? IDLE : INSERT;
endcase


endmodule



