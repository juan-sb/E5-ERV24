module fetch
(
 input[31:0] currPC,
 input clk,
 input nreset,
 output [31:0] nextPC
 );

	reg[31:0] q;
	 
	always @(posedge clk or negedge nreset) begin
		if (!nreset) q <= 0;
		else q <= currPC + 1;
	end

	assign nextPC = q;
 
endmodule