module  Max_Heapify(
    input               clk,
    input               rst,
    input               active_MH,      //from build queue
    input               decrese_size,   //from extract max
    input       [3:0]   heap_size,  //length
    input       [3:0]   root_i,
    input       [7:0]   left_right_data,
    input       [7:0]   largest_data,
    output              swap,
    output              finish,
    output      [3:0]   left_right,       //read_idx1
    output      [3:0]   largest_out,    //read_idx2 /swap_idx1
    output      [3:0]   root_idx_out    //swap_idx2
);

// parameter   IDLE = 3'd0,
//             COMP_L = 3'd1,
//             COMP_R = 3'd2,
//             SWAP = 3'd3,
//             FINISH = 3'd4;

parameter   IDLE = 3'd0,
            UPDATE_RL = 3'd1,
            COMP_L = 3'd2,
            COMP_R = 3'd3,
            SWAP = 3'd4,
            FINISH = 3'd5;

reg     [2:0]   state, next_state;
reg     [7:0]   next_largest, 
                next_root, 
                next_left, 
                next_right, 
                largest, 
                root_idx,
                left,
                right;
wire    active;


assign  active = (active_MH | decrese_size);
//assign  left = (largest << 1);
//assign  right = (largest << 1) + 4'd1;
assign  finish = (state == FINISH);
assign  swap = (state == SWAP) && (largest != root_idx);
assign  left_right = (state == COMP_L)? left[3:0] : right[3:0];

assign  largest_out = largest[3:0];
assign  root_idx_out = root_idx[3:0];

//===========================FSM============================
always @(posedge clk or posedge rst) begin
    if(rst) state <= IDLE;
    else    state <= next_state;
end

// always@(*)
// case(state)
//     IDLE:       next_state = (active)? COMP_L : IDLE;
//     COMP_L:     next_state = COMP_R;
//     COMP_R:     next_state = SWAP;
//     SWAP:       next_state = (largest != root_idx)? COMP_L : FINISH;
//     default:    next_state = IDLE;
// endcase

always@(*)
case(state)
    IDLE:       next_state = (active)? COMP_L : IDLE;
    UPDATE_RL:  next_state = COMP_L;
    COMP_L:     next_state = COMP_R;
    COMP_R:     next_state = SWAP;
    SWAP:       next_state = (largest != root_idx)? UPDATE_RL : FINISH;
    default:    next_state = IDLE;
endcase


//===========================Index============================
always @(posedge clk or posedge rst) begin
    if(rst) begin
        largest <= 8'd0;
        root_idx <= 8'd0;
        left <= 8'd0;
        right <= 4'd0;
    end
    else begin
        largest <= next_largest;
        root_idx <= next_root;
        left <= next_left;
        right <= next_right;
    end
end

always@(*)
case(state)
    IDLE:   begin   //0
        if(active_MH)  begin
            next_largest = root_i;
            next_root = root_i;
            next_left = root_i << 1;
            next_right = (root_i << 1) + 8'd1;
        end
        else    begin
            next_largest = 8'd1;
            next_root = 8'd1;
            next_left = 8'd2;
            next_right = 8'd3;
        end
    end
    UPDATE_RL:  begin   //1
        next_left = largest << 1;
        next_right = (largest << 1) + 8'd1;
        next_largest = largest;
        next_root = root_idx;
    end
    COMP_L:   begin     //2
        if((left <= heap_size-4'd1) && (left_right_data > largest_data))begin
            next_largest = left;
            next_left = left;
            next_right = right;
            next_root = root_idx;
        end
        else    begin
            next_largest = largest;
            next_left = left;
            next_right = right;
            next_root = root_idx;
        end
    end
    COMP_R: begin       //3
        if((right <= heap_size-4'd1) && (left_right_data > largest_data))begin
            next_largest = right;
            next_left = left;
            next_right = right;
            next_root = root_idx;
        end
        else    begin
            next_largest = largest;
            next_left = left;
            next_right = right;
            next_root = root_idx;
        end
        //a = 0;
    end
    SWAP:    begin      //4
        if(largest != root_idx) begin
            next_root = largest;
            next_largest = largest;
            next_left = left;
            next_right = right;
        end
        else    begin
            next_root = 8'd0;
            next_largest = largest;
            next_left = left;
            next_right = right;
        end
    end
    default:    begin   //5
        next_largest = 8'd0;
        next_root = 8'd0;
        next_left = left;
        next_right = right;
    end
endcase

endmodule


