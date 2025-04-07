module  Controller(
    input               clk,
    input               rst,
    input               col_end,
    input               row_end,
    input   [1:0]       M1_col_idx,
    input   [1:0]       M2_col_idx,
    input   [1:0]       M1_row_idx,
    output              valid,
    output              is_legal,
    output              change_row,
    output              busy,
    output              M1_wen,
    output              M2_wen,
    output  reg [1:0]   M1_col_size,
    output  reg [1:0]   M2_col_size 
);

parameter   INPUT_M1 = 2'd0,
            INPUT_M2 = 2'd1,
            COMPUTE_MM = 2'd2,
            OUTPUT_MM = 2'd3;

reg [1:0]   state, next_state;
wire        MM_finish;
reg [1:0]   M1_row_size, M2_row_size;

assign  valid = (state == OUTPUT_MM)? 1'b1 : 1'b0;
assign  is_legal = (M1_col_size == M2_row_size);
assign  change_row = (M2_col_idx == M2_col_size-1);
assign  busy = (state == COMPUTE_MM) || (state == OUTPUT_MM);
assign  MM_finish = (M1_row_idx == M1_row_size-1) && change_row && valid;
assign  M1_wen = (state == INPUT_M1);
assign  M2_wen = (state == INPUT_M2);


//===========================FSM============================
always @(posedge clk or posedge rst) begin
    if(rst) state <= INPUT_M1;
    else    state <= next_state;
end

always@(*)
case(state)
    INPUT_M1:   next_state = (row_end)? INPUT_M2 : INPUT_M1;
    INPUT_M2:   next_state = (row_end)? COMPUTE_MM : INPUT_M2;
    COMPUTE_MM: next_state = (M1_col_idx == M1_col_size-1 | ~is_legal)? OUTPUT_MM : COMPUTE_MM;
    default:    next_state = (MM_finish | ~is_legal)? INPUT_M1 : COMPUTE_MM;
endcase

//===========================Count column size============================
always @(posedge clk or posedge rst) begin
    if(rst) begin
        M1_col_size <= 2'd0;
        M2_col_size <= 2'd0;
    end
    else if(state == INPUT_M1)  begin
        if(col_end)
            if(row_end)    
                M1_col_size <= M1_col_size + 2'd1;
            else            
                M1_col_size <= 2'd0;
        else
            M1_col_size <= M1_col_size + 2'd1;
    end
    else if(state == INPUT_M2)   begin
        if(col_end)
            if(row_end)    
                M2_col_size <= M2_col_size + 2'd1;
            else            
                M2_col_size <= 2'd0;
        else
            M2_col_size <= M2_col_size + 2'd1;
    end
    else if (state == OUTPUT_MM)begin
        if(MM_finish | ~is_legal)   begin
            M1_col_size <= 2'd0;
            M2_col_size <= 2'd0;
        end
        else    begin
            M1_col_size <= M1_col_size;
            M2_col_size <= M2_col_size;
        end
    end
    else    begin
        M1_col_size <= M1_col_size;
        M2_col_size <= M2_col_size;
    end
end

//===========================Count row size============================
always @(posedge clk or posedge rst) begin
    if(rst) begin
        M1_row_size <= 2'd0;
        M2_row_size <= 2'd0;
    end
    else if(state == INPUT_M1)  begin
        if(col_end) 
            M1_row_size <= M1_row_size + 2'd1;
        else
            M1_row_size <= M1_row_size;
    end
    else if(state == INPUT_M2)   begin
        if(col_end) 
            M2_row_size <= M2_row_size + 2'd1;
        else
            M2_row_size <= M2_row_size;
    end
    else if(state == OUTPUT_MM)begin
        if(MM_finish | ~is_legal)   begin
            M1_row_size <= 2'd0;
            M2_row_size <= 2'd0;
        end
        else    begin
            M1_row_size <= M1_row_size;
            M2_row_size <= M2_row_size;
        end
    end
    else    begin
        M1_row_size <= M1_row_size;
        M2_row_size <= M2_row_size;
    end
end


endmodule


//==========================70/100============================
// module  Controller(
//     input               clk,
//     input               rst,
//     input               col_end,
//     input               row_end,
//     input   [1:0]       M1_col_idx,
//     input   [1:0]       M2_col_idx,
//     input   [1:0]       M1_row_idx,
//     output              valid,
//     output              is_legal,
//     output              change_row,
//     output              busy,
//     output              M1_wen,
//     output              M2_wen,
//     output  reg [1:0]   M1_col_size,
//     output  reg [1:0]   M2_col_size 
// );


// parameter   INPUT_M1 = 2'd0,
//             INPUT_M2 = 2'd1,
//             COMPUTE_MM = 2'd2;


// reg [1:0]   state, next_state;
// wire        MM_finish;
// reg [1:0]   M1_row_size, M2_row_size;

// assign  valid = (state == COMPUTE_MM)? ((M1_col_idx == M1_col_size) | ~is_legal) : 1'b0;
// assign  is_legal = (M1_col_size == M2_row_size);
// assign  change_row = (M2_col_idx == M2_col_size-1);
// assign  busy = (state == COMPUTE_MM);
// assign  MM_finish = (M1_row_idx == M1_row_size-1) && change_row && valid;
// assign  M1_wen = (state == INPUT_M1);
// assign  M2_wen = (state == INPUT_M2);


// //===========================FSM============================
// always @(posedge clk or posedge rst) begin
//     if(rst) state <= INPUT_M1;
//     else    state <= next_state;
// end

// always@(*)
// case(state)
//     INPUT_M1:   next_state = (row_end)? INPUT_M2 : INPUT_M1;
//     INPUT_M2:   next_state = (row_end)? COMPUTE_MM : INPUT_M2;
//     default: next_state = (MM_finish | ~is_legal)? INPUT_M1 : COMPUTE_MM;
// endcase

// //===========================Count column size============================
// always @(posedge clk or posedge rst) begin
//     if(rst) begin
//         M1_col_size <= 2'd0;
//         M2_col_size <= 2'd0;
//     end
//     else if(state == INPUT_M1)  begin
//         if(col_end)
//             if(row_end)    
//                 M1_col_size <= M1_col_size + 2'd1;
//             else            
//                 M1_col_size <= 2'd0;
//         else
//             M1_col_size <= M1_col_size + 2'd1;
//     end
//     else if(state == INPUT_M2)   begin
//         if(col_end)
//             if(row_end)    
//                 M2_col_size <= M2_col_size + 2'd1;
//             else            
//                 M2_col_size <= 2'd0;
//         else
//             M2_col_size <= M2_col_size + 2'd1;
//     end
//     else    begin
//         if(MM_finish | ~is_legal)   begin
//             M1_col_size <= 2'd0;
//             M2_col_size <= 2'd0;
//         end
//         else    begin
//             M1_col_size <= M1_col_size;
//             M2_col_size <= M2_col_size;
//         end
        
//     end
// end

// //===========================Count row size============================
// always @(posedge clk or posedge rst) begin
//     if(rst) begin
//         M1_row_size <= 2'd0;
//         M2_row_size <= 2'd0;
//     end
//     else if(state == INPUT_M1)  begin
//         if(col_end) 
//             M1_row_size <= M1_row_size + 2'd1;
//         else
//             M1_row_size <= M1_row_size;
//     end
//     else if(state == INPUT_M2)   begin
//         if(col_end) 
//             M2_row_size <= M2_row_size + 2'd1;
//         else
//             M2_row_size <= M2_row_size;
//     end
//     else    begin
//         if(MM_finish | ~is_legal)   begin
//             M1_row_size <= 2'd0;
//             M2_row_size <= 2'd0;
//         end
//         else    begin
//             M1_row_size <= M1_row_size;
//             M2_row_size <= M2_row_size;
//         end
        
//     end
// end



// endmodule

