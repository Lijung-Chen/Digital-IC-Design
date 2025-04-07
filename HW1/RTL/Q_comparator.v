module Q_comparator(
    input   signed  [4:0]   Q,
    input   signed  [4:0]   Din,
    output          [1:0]   Sel
);


assign  Sel[0] = (Din >= $signed(5'd0));
assign  Sel[1] = (Din >= Q);

endmodule

