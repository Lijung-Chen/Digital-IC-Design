module  MixColumns(
    input       [127:0] state_in,
    output   [127:0] state_out
);

// reg  [7:0] i;
// reg [7:0] j;

function [7:0] mb2; //multiply by 2
    input   [7:0]   x;

    if(x[7] == 1) mb2 = ((x << 1) ^ 8'h1b);
	else mb2 = x << 1;

endfunction


function [7:0] mb3; //multiply by 3
	input [7:0] x;
			
	mb3 = mb2(x) ^ x;

endfunction

genvar i;

generate
//always @(*) begin
    for(i = 0; i < 4; i = i+1)begin: m_col
        //j = i<<5;
        // state_out[j+31 : j+24] = mb2(state_in[(j + 31): (j + 24)]) ^ mb3(state_in[(j + 23): (j + 16)]) ^ state_in[(j + 15): (j + 8)] ^ state_in[(j + 7): j];
        // state_out[j+23 : j+16] = state_in[(j + 31): (j + 24)] ^ mb2(state_in[(j + 23): (j + 16)]) ^ mb3(state_in[(j + 15): (j + 8)]) ^ state_in[(j + 7): j];
        // state_out[j+15 : j+8] = state_in[(j + 31): (j + 24)] ^ state_in[(j + 23): (j + 16)] ^ mb2(state_in[(j + 15): (j + 8)]) ^ mb3(state_in[(j + 7): j]);
        // state_out[j+7 : j] = mb3(state_in[(j + 31): (j + 24)]) ^ state_in[(j + 23): (j + 16)] ^ state_in[(j + 15): (j + 8)] ^ mb2(state_in[(j + 7): j]);
        assign state_out[(i*32+24)+:8] = mb2(state_in[(i*32+24)+:8]) ^ mb3(state_in[(i*32+16)+:8]) ^ state_in[(i*32+8)+:8] ^ state_in[i*32+:8];
        assign state_out[(i*32+16)+:8] = state_in[(i*32+24)+:8] ^ mb2(state_in[(i*32+16)+:8]) ^ mb3(state_in[(i*32+8)+:8]) ^ state_in[i*32+:8];
        assign state_out[(i*32+8)+:8] = state_in[(i*32+24)+:8] ^ state_in[(i*32+16)+:8] ^ mb2(state_in[(i*32+8)+:8]) ^ mb3(state_in[i*32+:8]);
        assign state_out[i*32+:8] = mb3(state_in[(i*32+24)+:8]) ^ state_in[(i*32+16)+:8] ^ state_in[(i*32+8)+:8] ^ mb2(state_in[i*32+:8]);
    end
//end
endgenerate


endmodule


