module full_adder_data_flow (
        input [3:0] a,
        input [3:0] b,
		input cin,
		output [3:0] sum,
        output  cout
        );
    assign {cout,sum} = a + b + cin;
endmodule

module full_adder_carry_lookahead (
        input [3:0] a,
        input [3:0] b,
		input cin,
		output [3:0] sum,
        output  cout
        );
    wire [3:0] p;
	wire [3:0] g;
	wire [3:0] c;
	assign p = a ^ b; // propagate 
	assign g = a & b; // generate
	assign c[0] = cin;
	assign c[1] = g[0] | (p[0] & cin);
	assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
	assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
	assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & cin);
	assign sum = p ^ c;
endmodule

module full_adder_tb;
	// Inputs
	reg [3:0] a;
    reg [3:0] b;
    reg cin;
	// Outputs
    // full adder data flow(concatenation)
	wire [3:0] sum1;
    wire cout1;
    // full adder carry look ahead
    wire [3:0] sum2;
    wire cout2;
	// Instantiate the Unit Under Test (UUT) {for data flow full adder}
	full_adder_data_flow uut1 (
		.a(a), 
		.b(b),
		.cin(cin),
		.sum(sum1),
		.cout(cout1)
	);
	// Instantiate the Unit Under Test (UUT) {for carry look-ahead full adder}
	full_adder_carry_lookahead uut2 (
		.a(a), 
		.b(b),
		.cin(cin),
		.sum(sum2),
		.cout(cout2)
	);

 
	initial begin	
		$dumpfile("test.vcd");
    	$dumpvars(0,full_adder_tb);
	end

	initial begin
	// Initialize Inputs
	#0  a=1011;b=0011;cin=0;
	#10 b=0100;
	#10 b=0101;
	#10 b=0110;
	#10 b=0111;
	#10 cin=1;b=0011;
	#10 b=0100;
	#10 b=0101;
	#10 b=0110;
	#10 b=0111;
    #10;
	end  

	initial begin
		$monitor("\nt=%3d : a=%b | b=%b | cin=%b\nData flow full adder:-\n\tsum=%b | cout=%b \nCarry look-ahead full adder:-\n\tsum=%b | cout=%b ",$time,a,b,cin,sum1,cout1,sum2,cout2);
	end
 
endmodule