module jmp_ctrl(
	input [31:0] pc,
	input [31:0] imm,
	input [31:0] rs1,
	input [31:0] rs2,
	input [15:0] flags,
	input alu_z,
	input alu_n,
	
	input clk,
	input ena,
	input x,
	input nreset,
	
	output reg pc_wr,
	output reg [31:0] pc_out
);

always @(*) begin
	if(!nreset || !ena) begin
		pc_wr = 0;
		pc_out = 0;
	end

	else if(flags[10]) begin
		pc_out = rs1 + imm;
		pc_wr = 1;
	end
end

endmodule