// top module
// Lijung Chen: N26120113 

module MAS_2input(
    input signed [4:0]Din1,
    input signed [4:0]Din2,
    input [1:0]Sel,
    input signed[4:0]Q,
    output [1:0]Tcmp,
    output signed [4:0]TDout,
    output signed [3:0]Dout
);

ALU alu1(
    .Sel(Sel),
    .Din1(Din1),
    .Din2(Din2),
    .Dout(TDout)
);

Q_comparator  cmp(
    .Q(Q),
    .Din(TDout),
    .Sel(Tcmp)
);

ALU alu2(
    .Sel(Tcmp),
    .Din1(TDout),
    .Din2(Q),
    .Dout(Dout)
);


endmodule