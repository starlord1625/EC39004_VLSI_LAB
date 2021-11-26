module cmos_inverter (o,i);
	input i;
	output o;

	supply1 vdd;
	supply0 gnd;

	pmos(o,vdd,i);
	nmos(o,gnd,i);

endmodule

module Mux_1x2 (o0,o1,sel,in);
	input sel,in;
	output o0,o1;

	wire selb;

	cmos_inverter nt(selb,sel);
	//Transmission logic gates
	cmos(o0,in,selb,sel);
	cmos(o1,in,sel,selb);

endmodule

module Mux_1x4(out,s,in);
	input in;
	input [1:0]s;
	output [3:0]out;

	wire i0,i1;
	// First Layer of the Demux
	Mux_1x2 S11(i0,i1,s[1],in);
	// Second Layer of the Demux
	Mux_1x2 S21(out[0],out[1],s[0],i0);
	Mux_1x2 S22(out[2],out[3],s[0],i1);

endmodule

module test_bench();
	reg in;
	reg [1:0] sel;
	wire [3:0]out;

	Mux_1x4 uut(out,sel,in);

	initial
	begin
		$monitor("time=%5d, input=%b, select=%b, output=%b",$time,in,sel,out);
		//initialisation of select lines
		#0 in = 1'b1;sel = 2'b00;
		#5 sel = 2'b01;
		#5 sel = 2'b10;
		#5 sel = 2'b11;
		#5 in = 1'b0;sel = 2'b00;
		#5 sel = 2'b01;
		#5 sel = 2'b10;
		#5 sel = 2'b11;
		#5 $finish;
	end

	initial begin
		$dumpfile("test.vcd");
		$dumpvars;
	end

endmodule