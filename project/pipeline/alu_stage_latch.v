module alu_stage_latch
(
 input [31:0] result,
 input [4:0] rd,
 input [16:0] flags,
 input clk,
 input ena,
 input x,
 input [11:0] csr,
 input [31:0] rs1,
 input [31:0] imm,
 input [2:0] funct3,
 output reg [31:0] result_out,
 output reg [4:0] rd_out,
 output reg [16:0] flags_out,
 output reg [11:0] csr_out,
 output reg [31:0] rs1_out,
 output reg [31:0] imm_out,
 output reg [2:0] funct3_out
 );
	
always @(posedge clk) begin
	if (ena) begin
		result_out <= result;
		rd_out <= rd;
		flags_out <= flags;
		csr_out <= csr;
		rs1_out <= rs1;
		imm_out <= imm;
		funct3_out <= funct3;
	end
	else begin
		result_out <= 0;
		rd_out <= 0;
		flags_out <= 0;
		csr_out <= 0;
		rs1_out <= 0;
		imm_out <= 0;
		funct3_out <= 0;
	end
end

endmodule