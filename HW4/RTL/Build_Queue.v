//mode = 0

module  Build_Queue(
    input               clk,
    input               rst,
    input       [2:0]   active_mode,
    input       [3:0]   heap_size,  //length
    input               finish_MH,
    output              active_MH,
    output              finish,
    output  reg [3:0]   root_i
);

parameter   IDLE = 2'd0,
            MAX_HEAP = 2'd1,
            FINISH = 2'd2;

reg     [1:0]   state, next_state;


assign  active_MH = (state == MAX_HEAP);
assign  finish = (state == FINISH) && (root_i < 4'd1);


//===========================FSM============================
always @(posedge clk or posedge rst) begin
    if(rst) state <= IDLE;
    else    state <= next_state;
end

always@(*)
case(state)
    IDLE:       next_state = (active_mode == 3'd0)? MAX_HEAP : IDLE;
    MAX_HEAP:   next_state = (finish_MH)? FINISH : MAX_HEAP;
    default:    next_state = (root_i < 4'd1)? IDLE : MAX_HEAP;
endcase


always @(posedge clk or posedge rst) begin
    if(rst) 
        root_i <= 4'd0;
    else if(state == IDLE && active_mode == 3'd0)    
        root_i <= heap_size >> 1;
    else if(finish_MH)
        root_i <= root_i - 4'd1;
    else 
        root_i <= root_i;
end

endmodule

