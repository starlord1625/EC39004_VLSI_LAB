module design_2_1_MUX(
		input a0,
		input a1,
		input s,
		output z
		);
	wire T1,T2,sbar;
	not(sbar,s);
	and (T1,a1,s) , (T2,a0,sbar);
	or (z,T1,T2);
endmodule

module layer_0_8_8_MUX(
        input [7:0] x,
        input cntrl,
        output [7:0] z
        );
	design_2_1_MUX b1(x[0],x[7],cntrl,z[0]);
	design_2_1_MUX b2(x[1],x[6],cntrl,z[1]);
	design_2_1_MUX b3(x[2],x[5],cntrl,z[2]);
	design_2_1_MUX b4(x[3],x[4],cntrl,z[3]);
	design_2_1_MUX b5(x[4],x[3],cntrl,z[4]);
	design_2_1_MUX b6(x[5],x[2],cntrl,z[5]);
	design_2_1_MUX b7(x[6],x[1],cntrl,z[6]);
	design_2_1_MUX b8(x[7],x[0],cntrl,z[7]);
endmodule

module layer_1_8_8_MUX(
        input [7:0] x,
        input  sel,
        output [7:0] z
        );
	design_2_1_MUX b1(x[0],1'b0,sel,z[0]);
	design_2_1_MUX b2(x[1],x[0],sel,z[1]);
	design_2_1_MUX b3(x[2],x[1],sel,z[2]);
	design_2_1_MUX b4(x[3],x[2],sel,z[3]);
	design_2_1_MUX b5(x[4],x[3],sel,z[4]);
	design_2_1_MUX b6(x[5],x[4],sel,z[5]);
	design_2_1_MUX b7(x[6],x[5],sel,z[6]);
    design_2_1_MUX b8(x[7],x[6],sel,z[7]);
endmodule

module layer_2_8_8_MUX(
        input [7:0] x,
        input  sel,
        output [7:0] z
        );
	design_2_1_MUX b1(x[0],1'b0,sel,z[0]);
	design_2_1_MUX b2(x[1],1'b0,sel,z[1]);
	design_2_1_MUX b3(x[2],x[0],sel,z[2]);
	design_2_1_MUX b4(x[3],x[1],sel,z[3]);
	design_2_1_MUX b5(x[4],x[2],sel,z[4]);
	design_2_1_MUX b6(x[5],x[3],sel,z[5]);
	design_2_1_MUX b7(x[6],x[4],sel,z[6]);
    design_2_1_MUX b8(x[7],x[5],sel,z[7]);
endmodule

module layer_3_8_8_MUX(
        input [7:0] x,
        input  sel,
        output [7:0] z
        );
	design_2_1_MUX b1(x[0],1'b0,sel,z[0]);
	design_2_1_MUX b2(x[1],1'b0,sel,z[1]);
	design_2_1_MUX b3(x[2],1'b0,sel,z[2]);
	design_2_1_MUX b4(x[3],1'b0,sel,z[3]);
	design_2_1_MUX b5(x[4],x[0],sel,z[4]);
	design_2_1_MUX b6(x[5],x[1],sel,z[5]);
	design_2_1_MUX b7(x[6],x[2],sel,z[6]);
    design_2_1_MUX b8(x[7],x[3],sel,z[7]);
endmodule

module barrel_shifter(
        input [7:0] x,
        input [2:0] sel,
        input cntrl,
        output [7:0] z
        );
    wire [7:0]z0;
    wire [7:0]z1;
    wire [7:0]z2;
    wire [7:0]z3;
    layer_0_8_8_MUX l0(x,cntrl,z0);
    layer_1_8_8_MUX l1(z0,sel[0],z1);
    layer_2_8_8_MUX l2(z1,sel[1],z2);
    layer_3_8_8_MUX l3(z2,sel[2],z3);
    layer_0_8_8_MUX l4(z3,cntrl,z);
endmodule

module barrel_shifter_tb;
	// Inputs
	reg [7:0] x;
	reg  [2:0]sel;
    reg cntrl;
	// Outputs
	wire [7:0]z;
	// Instantiate the Unit Under Test (UUT)
	barrel_shifter uut (
		.x(x), 
		.sel(sel), 
        .cntrl(cntrl),
		.z(z)
	);
 
	initial begin	
		$dumpfile("test.vcd");
    	$dumpvars(0,barrel_shifter_tb);
	end

	initial begin
	// Initialize Inputs
	#0  x = 8'b10101101;sel=3'b000 ;cntrl=1'b0;
    #10 sel=3'b001 ;cntrl=1'b0;
	#10 sel=3'b010 ;cntrl=1'b0;
	#10 sel=3'b011 ;cntrl=1'b0;
	#10 sel=3'b100 ;cntrl=1'b0;
	#10 sel=3'b101 ;cntrl=1'b0;
	#10 sel=3'b110 ;cntrl=1'b0;
	#10 sel=3'b111 ;cntrl=1'b0;
    #10 sel=3'b000 ;cntrl=1'b1;
    #10 sel=3'b001 ;cntrl=1'b1;
	#10 sel=3'b010 ;cntrl=1'b1;
	#10 sel=3'b011 ;cntrl=1'b1;
	#10 sel=3'b100 ;cntrl=1'b1;
	#10 sel=3'b101 ;cntrl=1'b1;
	#10 sel=3'b110 ;cntrl=1'b1;
	#10 sel=3'b111 ;cntrl=1'b1;
    #10;
	end  

	initial begin
		$monitor("t=%3d x=%b,sel=%b,z=%b,cntrl=%b \n",$time,x,sel,z,cntrl);
	end
 
endmodule