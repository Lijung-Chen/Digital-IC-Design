`timescale 1ns/10ps
module MM( in_data, col_end, row_end, is_legal, out_data, rst, clk , change_row, valid, busy);
input   clk;
input   rst;
input   col_end;
input   row_end;
input      [7:0]     in_data;

output  signed [19:0]   out_data;
output is_legal;
output  change_row, valid, busy;

wire   M1_wen,  M2_wen;
wire   [1:0]    M1_col_idx,
                M2_col_idx,
                M1_row_idx,
                M1_col_size,
                M2_col_size;
wire    [3:0]   M1_read_idx,
                M2_read_idx;
wire    [7:0]   M1_data,
                M2_data;

Controller ctrl(
    .clk        (clk),
    .rst        (rst),
    .col_end    (col_end),
    .row_end    (row_end),
    .M1_col_idx (M1_col_idx),
    .M2_col_idx (M2_col_idx),
    .M1_row_idx (M1_row_idx),
    .valid      (valid),
    .is_legal   (is_legal),
    .change_row (change_row),
    .busy       (busy),
    .M1_wen     (M1_wen),
    .M2_wen     (M2_wen),
    .M1_col_size(M1_col_size),
    .M2_col_size(M2_col_size)
);

Matrix_Reg  M1(
    .clk            (clk),
    .rst            (rst),
    .write_idx_rst  (busy),  //busy
    .wen            (M1_wen),
    .read_idx       (M1_read_idx),
    .write_data     (in_data),
    .read_data      (M1_data)
);

Matrix_Reg  M2(
    .clk            (clk),
    .rst            (rst),
    .write_idx_rst  (busy),  //busy
    .wen            (M2_wen),
    .read_idx       (M2_read_idx),
    .write_data     (in_data),
    .read_data      (M2_data)
);

Mul_Adder   mul_adder(
    .clk                (clk),
    .rst                (rst),
    .Mul_Adder_active   (busy),   //state = COMPUTE_MM (busy)
    .M1_col_size        (M1_col_size),
    .M2_col_size        (M2_col_size),
    .M1_data            (M1_data),
    .M2_data            (M2_data),
    .M1_col_idx         (M1_col_idx),
    .M2_col_idx         (M2_col_idx),
    .M1_row_idx         (M1_row_idx),
    .M1_read_idx        (M1_read_idx),
    .M2_read_idx        (M2_read_idx),
    .out_data           (out_data)
);

endmodule
