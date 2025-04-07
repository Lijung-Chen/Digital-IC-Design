module  MUX(
    input   [2:0]   active_mode,
    //-----------swap-------------
    //MH(0,1)
    input           swap_MH,
    input   [3:0]   largest,        //swap_idx1 / read_idx2
    input   [3:0]   root_idx_MH,    //swap_idx2
    //IV,ID(2,3)
    input           swap_IV,
    input   [3:0]   parent,         //swap_idx1 /read_idx1
    input   [3:0]   read_idx_IV,    //swap_idx2 /read_idx2
    //------------read-------------
    //MH(0,1)
    input   [3:0]   left_right,     //read_idx1
    //IV,ID(2,3)
    //WR(4)
    input   [3:0]   read_idx_WR,    //read_idx1

    //-----------swap-------------
    output  reg         swap,
    output  reg [3:0]   swap_idx1,
    output  reg [3:0]   swap_idx2,
    //------------read-------------
    output  reg [3:0]   read_idx1,
    output  reg [3:0]   read_idx2
);

//swap
always@(*)begin
    case(active_mode)
        3'd2:   begin
            swap = swap_IV;
            swap_idx1 = parent;
            swap_idx2 = read_idx_IV;
        end
        3'd3:   begin
            swap = swap_IV;
            swap_idx1 = parent;
            swap_idx2 = read_idx_IV;
        end
        default:    begin
            swap = swap_MH;
            swap_idx1 = largest;
            swap_idx2 = root_idx_MH;
        end
    endcase
end

//read
always@(*)begin
    case(active_mode)
        3'd0:   begin
            read_idx1 = left_right;
            read_idx2 = largest;
        end
        3'd1:   begin
            read_idx1 = left_right;
            read_idx2 = largest;
        end
        3'd2:   begin
            read_idx1 = parent;
            read_idx2 = read_idx_IV;
        end
        3'd3:   begin
            read_idx1 = parent;
            read_idx2 = read_idx_IV;
        end
        default:    begin
            read_idx1 = read_idx_WR;
            read_idx2 = read_idx_IV;
        end
    endcase
end

endmodule