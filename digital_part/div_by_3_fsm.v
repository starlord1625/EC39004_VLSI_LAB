
`define a 3'd0  // remainder is 0
`define b 3'd1  // remainder is 1
`define c 3'd2  // remainder i 2

module div_by_3_fsm(in,out);
	input [7:0] in;
	output reg [7:0] out;

	integer i;
	reg [2:0] state,nstate;  //state and next state

    always @(in) 
    begin
		state=`a;  // intial state 
	    for(i=7;i>=0;i=i-1)  // looping to assign for all seq output
	    begin
		    case(state)
			    `a: if(in[i])
				    	begin
					    	nstate = `b;  // next state
						    out[i] = 1'b0;  // ouput single bit
    					end
	    			else 
		    			begin
			    			nstate = `a;
				    		out[i] = 1'b1;
					    end
    			`b: if(in[i])
	    				begin
		    				nstate = `a;
			    			out[i] = 1'b1;
				    	end
    				else 
	    				begin
		    				nstate = `c;
			    			out[i] = 1'b0;
				    	end
    			`c: if(in[i])
	    				begin
		    				nstate = `c;
			    			out[i] = 1'b0;
				    	end
    				else 
	    				begin
		    				nstate = `b;
			    			out[i] = 1'b0;
				    	end
    		endcase
	    	state=nstate;
	    end
    end
endmodule

module div_by_3_fsm_tb();
	// input
	reg [7:0] in;
	// output
	wire [7:0] out;
	// instantion
	div_by_3_fsm uut(in,out);

	initial
	begin
		$monitor("time=%5d, in = %b, out = %b",$time,in,out);
		in = 8'b10101001;
		#50 in=8'b10101010;
		#50 in=8'b11111111;
		#50 $finish;
	end

	initial begin
		$dumpfile("test.vcd");
		$dumpvars;
	end
endmodule