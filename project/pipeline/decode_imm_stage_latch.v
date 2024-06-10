module decode_imm_stage_latch
(
 input [31:0] imm,
 input [4:0] rs1,
 input [4:0] rs2,
 input [4:0] rd,
 input [31:0] pc,
 input [2:0] funct3,
 input [16:0] flags, 
 input clk,
 input ena,
 input x,
 input [1:0] acc_size,
 output reg [31:0] imm_out,
 output reg [4:0] rs1_out,
 output reg [4:0] rs2_out,
 output reg [4:0] rd_out,
 output reg [31:0] pc_out,
 output reg [2:0] funct3_out,
 output reg [16:0] flags_out,
 output reg [1:0] acc_size_out
 );
	
always @(posedge clk) begin
	if (ena) begin
		imm_out <= imm;
		rs1_out <= rs1;
		rs2_out <= rs2;
		rd_out <= rd;
		pc_out <= pc;
		funct3_out <= funct3;
		flags_out <= flags;
		acc_size_out <= acc_size;
	end else begin
		imm_out <= 0;
		rs1_out <= 0;
		rs2_out <= 0;
		rd_out <= 0;
		pc_out <= 0;
		funct3_out <= 0;
		flags_out <= 0;
		acc_size_out <= 0;
	end
end


endmodule