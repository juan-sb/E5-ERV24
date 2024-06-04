module alu_stage_latch
(
 input [31:0] result,
 input [4:0] rd,
 input rd_en,
 input clk,
 input ena,
 input x,
 output reg [31:0] result_out,
 output reg [4:0] rd_out,
 output reg rd_en_out
 );
	
always @(posedge clk) begin
	if (ena) begin
	
		result_out <= result;
		rd_out <= rd;
		rd_en_out <= rd_en;
		
	end
end

endmodule