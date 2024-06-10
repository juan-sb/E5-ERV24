module jmp_ctrl(
	input [31:0] pc,
	input [31:0] imm,
	input [31:0] rs1,
	input [31:0] rs2,
	input [16:0] flags,
	input [2:0] funct3,
	input alu_z,
	input alu_n,
	
	input clk,
	input ena,
	input x,
	input nreset,
	
	output wire pc_wr,
	output wire [31:0] pc_out,
	output wire branch_taken,
	output wire was_predicted_taken
);

wire is_jalr = flags[10];
wire is_branch = flags[12];
assign was_predicted_taken = flags[16];

wire branch_beq_bne = (funct3[2:1] == 2'b00) && ((!funct3[0]) == alu_z); // 0: beq, 1: bne
wire branch_other = ((funct3[2:1] == 2'b10) || (funct3[2:1] == 2'b11)) && (funct3[0] ^ alu_n); // 0: blt, branch si n=1, 1: bge, branch si n=0, unsigned o signed
assign branch_taken = is_branch && (branch_other || branch_beq_bne);
wire [31:0] rs1plusimm = (rs1 + imm) & 32'hFFFFFFFE;
wire [31:0] pcplusimm = pc + imm;
wire [31:0] pcplus4 = pc + 4;
assign pc_wr = ((~nreset) || (~ena)) ? 1'b0 : (is_jalr | (branch_taken ^ was_predicted_taken));
assign pc_out = is_jalr ? rs1plusimm : (branch_taken && !was_predicted_taken ? pcplusimm : pcplus4);


endmodule