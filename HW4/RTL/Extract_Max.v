//mode = 1

module  Extract_Max(
    input           clk,
    input           rst,
    input   [2:0]   active_mode,
    input   [3:0]   heap_size,  //length
    input           finish_MH,
    //output          active_MH,
    output          finish,
    output          decrese_size
);


parameter   IDLE = 2'd0,
            MAX_HEAP = 2'd1,
            FINISH = 2'd2;

reg     [1:0]   state, next_state;


//assign  active_MH = (state == MAX_HEAP);
assign  finish = (state == FINISH);
assign  decrese_size = (state == IDLE && active_mode == 3'd1);

//===========================FSM============================
always @(posedge clk or posedge rst) begin
    if(rst) state <= IDLE;
    else    state <= next_state;
end

always@(*)
case(state)
    IDLE:       next_state = (active_mode == 3'd1)? MAX_HEAP : IDLE;
    MAX_HEAP:   next_state = (finish_MH)? FINISH : MAX_HEAP;
    default:    next_state = IDLE;
endcase


endmodule