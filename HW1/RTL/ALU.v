module ALU(
    input               [1:0]   Sel,
    input       signed  [4:0]   Din1,
    input       signed  [4:0]   Din2,
    output  reg signed  [4:0]   Dout
);

always @(*) begin
    case (Sel)
        2'b00:  Dout = Din1 + Din2;
        2'b11:  Dout = Din1 - Din2;
        default: Dout = Din1;
    endcase
end

endmodule
