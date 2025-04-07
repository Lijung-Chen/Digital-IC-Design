module CIPU(
input       clk, 
input       rst,
input       [7:0]people_thing_in,
input       ready_fifo,
input       ready_lifo,
input       [7:0]thing_in,
input       [3:0]thing_num,
output      valid_fifo,
output      valid_lifo,
output      valid_fifo2,
output      [7:0]people_thing_out,
output      [7:0]thing_out,
output      done_thing,
output      done_fifo,
output      done_lifo,
output      done_fifo2);



FIFO    fifo(
    .clk(clk),
    .rst(rst),
    .ready_fifo(ready_fifo),
    .people_thing_in(people_thing_in),
    .valid_fifo(valid_fifo),
    .done_fifo(done_fifo),
    .people_thing_out(people_thing_out)
);

LIFO_FIFO   lifo_fifo(
    .clk(clk),
    .rst(rst),
    .ready_lifo(ready_lifo),
    .thing_in(thing_in),
    .thing_num(thing_num),
    .valid_lifo(valid_lifo),
    .done_lifo(done_lifo),
    .done_thing(done_thing),
    .valid_fifo2(valid_fifo2),
    .done_fifo2(done_fifo2),
    .thing_out(thing_out)
);

endmodule