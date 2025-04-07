//mode = 4

module  Write_RAM(
    input               clk,
    input               rst,
    input       [2:0]   active_mode,
    input       [3:0]   heap_size,  //length
    output              RAM_valid, 
    output              done,
    output  reg [3:0]   read_idx    //for Data_reg read_idx1
);

parameter   IDLE = 2'd0,
            WRITE = 2'd1;

reg     [1:0]   state, next_state;

assign  RAM_valid = (state == WRITE) && (read_idx != heap_size);
assign  done = (state == WRITE) && (read_idx == heap_size) ;

//===========================FSM============================
always @(posedge clk or posedge rst) begin
    if(rst) state <= IDLE;
    else    state <= next_state;
end

always@(*)
case(state)
    IDLE:   next_state = (active_mode == 3'd4)? WRITE : IDLE;
    WRITE:  next_state = (done)? IDLE : WRITE;
endcase

//===========================Index============================
always @(posedge clk or posedge rst) begin
    if(rst)
        read_idx <= 4'd0;
    else if(state == IDLE && active_mode == 3'd4)
        read_idx <= 4'd1;
    else 
        read_idx <= read_idx + 4'd1;
end

endmodule