module alu_stage_latch
(
 input [31:0] result,
 input [4:0] rd,
 input [16:0] flags,
 input clk,
 input ena,
 input x,
 output reg [31:0] result_out,
 output reg [4:0] rd_out,
 output reg [16:0] flags_out
 );
	
always @(posedge clk) begin
	if (ena) begin
		result_out <= result;
		rd_out <= rd;
		flags_out <= flags;
	end
	else begin
		result_out <= 0;
		rd_out <= 0;
		flags_out <= 0;
	end
end

endmodule