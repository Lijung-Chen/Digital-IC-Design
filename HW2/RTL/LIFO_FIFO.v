module  LIFO_FIFO(
    input           clk,
    input           rst,
    input           ready_lifo,
    input   [7:0]   thing_in,
    input   [3:0]   thing_num,
    output          valid_lifo,
    output          done_lifo,
    output          done_thing,
    output          valid_fifo2,
    output          done_fifo2,
    output  [7:0]   thing_out
);

parameter   IDLE = 2'd0,
            W_DATA = 2'd1,
            R_DATA_LIFO = 2'd2,
            R_DATA_FIFO = 2'd3;

reg [1:0] state, next_state;
reg [7:0] register [0:15];
reg [3:0] write_ptr, read_ptr;
integer i;
wire    wen;
reg [3:0] pop_thing_num;
wire    thing_num_is0;

assign  thing_num_is0 = (thing_num == 4'd0);
assign  done_thing = (thing_num_is0)? (pop_thing_num == 4'd1) : (pop_thing_num == thing_num);
assign  valid_lifo = (state == R_DATA_LIFO) && ~done_thing;
assign  done_lifo = (thing_in == 8'd36);  //$
assign  valid_fifo2 = (state == R_DATA_FIFO) && ~done_fifo2;
assign  done_fifo2 = (state == R_DATA_FIFO) && (read_ptr == write_ptr);
assign  thing_out = (state == R_DATA_LIFO)? (thing_num_is0)? 8'd48: register[write_ptr-4'd1] : register[read_ptr];  ///

assign  wen = (state == W_DATA) && (thing_in != 8'd59) && (thing_in != 8'd36);


//===========================FSM============================
always @(posedge clk) begin
    if(rst) state <= IDLE;
    else    state <= next_state;
end

always@(*)
case(state)
    IDLE:   begin
        if(ready_lifo)
            next_state = W_DATA;
        else            
            next_state = IDLE;
    end
    W_DATA: begin
        if(thing_in == 8'd59)   //;
            next_state = R_DATA_LIFO;
        else if(done_lifo)
            next_state = R_DATA_FIFO;
        else
            next_state = W_DATA;
    end
    R_DATA_LIFO:    begin
        if(done_thing)
            next_state = W_DATA;
        else
            next_state = R_DATA_LIFO;
    end
    R_DATA_FIFO:    begin
        if(done_fifo2)
            next_state = IDLE;
        else
            next_state = R_DATA_FIFO;
    end
endcase

//===========================data register===========================
always @(posedge clk) begin
    if(rst) begin
        for(i=0; i<16; i=i+1)
            register[i] <= 32'd0;
    end
    else if(wen)
        register[write_ptr] <= thing_in;
    else 
        register[write_ptr] <= register[write_ptr];
end

//===========================pointer===========================
always @(posedge clk) begin
    if(rst)
        write_ptr <= 4'd0;  //read ptr for lifo

    else if(state == IDLE)
        write_ptr <= 4'd0;

    else if(wen)
        write_ptr <= write_ptr + 4'd1;

    else if(valid_lifo && ~thing_num_is0) //lifo pop
        write_ptr <= write_ptr - 4'd1;

    else 
        write_ptr <= write_ptr;
end

always @(posedge clk) begin
    if(rst) 
        read_ptr <= 4'd0;   //read ptr for fifo

    else if(state == IDLE || state == W_DATA)
        read_ptr <= 4'd0;

    else if(valid_fifo2)    //fifo pop
        read_ptr <= read_ptr + 4'd1;

    else 
        read_ptr <= read_ptr;
end

always @(posedge clk) begin
    if(rst) 
        pop_thing_num <= 4'd0;
    else if(valid_lifo)
        pop_thing_num <= pop_thing_num + 4'd1;
    else
        pop_thing_num <= 4'd0;
end


endmodule
