module FIFO(
    input           clk,
    input           rst,
    input           ready_fifo,
    input   [7:0]   people_thing_in,
    output          valid_fifo,
    output          done_fifo,
    output  [7:0]   people_thing_out
);

parameter   IDLE = 2'd0,
            W_DATA = 2'd1,
            R_DATA = 2'd2;

reg [1:0] state, next_state;
reg [7:0] register [0:15];
reg [3:0] read_ptr, write_ptr;
integer i;
wire    wen;


assign  valid_fifo = (state == R_DATA) && ~done_fifo;
assign  done_fifo = (state == R_DATA) && (read_ptr == write_ptr);
assign  people_thing_out = register[read_ptr];

assign  wen = (state == W_DATA) && (people_thing_in >= 8'd65) && (people_thing_in <= 8'd90);   //A~Z


//===========================FSM============================
always @(posedge clk) begin
    if(rst) state <= IDLE;
    else    state <= next_state;
end

always@(*)
case(state)
    IDLE:   begin
        if(ready_fifo)  
            next_state = W_DATA;
        else            
            next_state = IDLE;
    end
    W_DATA: begin
        if(people_thing_in == 8'd36)    //$
            next_state = R_DATA;
        else    
            next_state = W_DATA;
    end
    default:    begin
        if(done_fifo)
            next_state = IDLE;
        else
            next_state = R_DATA;
    end
endcase

//===========================data register===========================
always @(posedge clk) begin
    if(rst) begin
        for(i=0; i<16; i=i+1)
            register[i] <= 32'd0;
    end
    else if(wen)
        register[write_ptr] <= people_thing_in;
    else 
        register[write_ptr] <= register[write_ptr];
end

//===========================pointer===========================
always @(posedge clk) begin
    if(rst) begin
        write_ptr <= 4'd0;
        read_ptr <= 4'd0;
    end
    else if(state == IDLE)begin
        write_ptr <= 4'd0;
        read_ptr <= 4'd0;
    end
    else if(wen)
        write_ptr <= write_ptr + 4'd1;
    else if(valid_fifo)
        read_ptr <= read_ptr + 4'd1;
    else begin
        write_ptr <= write_ptr;
        read_ptr <= read_ptr;
    end
end


endmodule