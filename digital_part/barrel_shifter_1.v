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

module layer_1_8_8_MUX(
        input [7:0] x,
        input  sel,
        input cntrl,
        output [7:0] z
        );
    wire ip1;
    design_2_1_MUX a1(1'b0,x[7],cntrl,ip1);
	design_2_1_MUX b1(x[0],ip1,sel,z[0]);
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
        input cntrl,
        output [7:0] z
        );
    wire ip1,ip2;
    design_2_1_MUX a1(1'b0,x[6],cntrl,ip1);
    design_2_1_MUX a2(1'b0,x[7],cntrl,ip2);
	design_2_1_MUX b1(x[0],ip1,sel,z[0]);
	design_2_1_MUX b2(x[1],ip2,sel,z[1]);
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
        input cntrl,
        output [7:0] z
        );
    wire ip1,ip2,ip3,ip4;
    design_2_1_MUX a1(1'b0,x[4],cntrl,ip1);
    design_2_1_MUX a2(1'b0,x[5],cntrl,ip2);
    design_2_1_MUX a3(1'b0,x[6],cntrl,ip3);
    design_2_1_MUX a4(1'b0,x[7],cntrl,ip4);
	design_2_1_MUX b1(x[0],ip1,sel,z[0]);
	design_2_1_MUX b2(x[1],ip2,sel,z[1]);
	design_2_1_MUX b3(x[2],ip3,sel,z[2]);
	design_2_1_MUX b4(x[3],ip4,sel,z[3]);
	design_2_1_MUX b5(x[4],x[0],sel,z[4]);
	design_2_1_MUX b6(x[5],x[1],sel,z[5]);
	design_2_1_MUX b7(x[6],x[2],sel,z[6]);
    design_2_1_MUX b8(x[7],x[3],sel,z[7]);
endmodule

module structural_rotational(
        input [7:0] x,
        input [2:0] sel,
        input cntrl,
        output [7:0] z
        );
    wire [7:0]z1;
    wire [7:0]z2;
    layer_1_8_8_MUX l1(x,sel[0],cntrl,z1);
    layer_2_8_8_MUX l2(z1,sel[1],cntrl,z2);
    layer_3_8_8_MUX l3(z2,sel[2],cntrl,z);
endmodule

module structural_rotational_tb;
	// Inputs
	reg [7:0] x;
	reg  [2:0]sel;
    reg cntrl;
	// Outputs
	wire [7:0]z;
	// Instantiate the Unit Under Test (UUT)
	structural_rotational uut (
		.x(x), 
		.sel(sel), 
        .cntrl(cntrl),
		.z(z)
	);
 
	initial begin	
		$dumpfile("test.vcd");
    	$dumpvars(0,structural_rotational_tb);
	end

	initial begin
	// Initialize Inputs
	#0  x = 8'b11001100;sel=3'b000 ;cntrl=1'b0;
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