module fetch
(
 input[31:0] currPC,
 input clk,
 input nreset,
 input en,
 output [31:0] nextPC
 );

	reg[31:0] q;
	 
	always @(posedge clk or negedge nreset) begin
		if (!nreset) q <= 0;
		else if(en) q <= currPC + 4;
	end

	assign nextPC = q;
 
endmodule