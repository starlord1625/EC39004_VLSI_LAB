`timescale 10 ns/1 ns

module CLK();
	
	reg clock;

	initial
	clock = 1'b0;

	always
	begin
		if(clock)
			#1 clock = ~clock;
		else 
			#3 clock = ~clock;
	end

	initial
	#30 $finish;

	initial
	$monitor("time = %d*10 ns, clock = %b",$time ,clock);

	initial begin
		$dumpfile("test.vcd");
		$dumpvars;
	end

endmodule