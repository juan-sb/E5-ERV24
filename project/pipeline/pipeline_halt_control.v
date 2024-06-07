module pipeline_halt_control(
	input wire [16:0] decoded_flags,
	input wire [4:0] decoded_rs1,
	input wire [4:0] decoded_rs2,
	input wire [4:0] decoded_rd,
	input wire [16:0] reg_access_flags,
	input wire [4:0] reg_access_rs1,
	input wire [4:0] reg_access_rs2,
	input wire [4:0] reg_access_rd,
	input wire [16:0] alu_flags,
	input wire [4:0] alu_rd,
	input wire [16:0] post_alu_flags,
	input wire [4:0] post_alu_rd,
	output reg fetch_en,
	output reg decoded_latch_en,
	output reg reg_access_latch_en,
	output reg alu_latch_en,
	output wire jmpctrl_en
);

// -------- Decoder has instruction that needs a register that will be written
wire decoded_needs_regaccess_write;
assign decoded_needs_regaccess_write = reg_access_flags[0] && (reg_access_rd != 5'b0) && ((decoded_rs1 === reg_access_rd) || (decoded_rs2 === reg_access_rd));
wire decoded_needs_alu_write;
assign decoded_needs_alu_write = alu_flags[0] && (alu_rd != 5'b0) && ((decoded_rs1 === alu_rd) || (decoded_rs2 === alu_rd));
wire decoded_needs_postalu_write;
assign decoded_needs_postalu_write = post_alu_flags[0] && (post_alu_rd != 5'b0) && ((decoded_rs1 === post_alu_rd) || (decoded_rs2 === post_alu_rd));

wire decoded_blocked;
assign decoded_blocked = decoded_needs_regaccess_write || decoded_needs_alu_write || decoded_needs_postalu_write;
// ---------

// -------- Reg access has instruction that needs a register that will be written
wire regaccess_needs_alu_write;
assign regaccess_needs_alu_write = alu_flags[0] & (alu_rd != 5'b0) & ((reg_access_rs1 === alu_rd) || (reg_access_rs2 === alu_rd));
wire regaccess_needs_postalu_write;
assign regaccess_needs_postalu_write = post_alu_flags[0] & (post_alu_rd != 5'b0) & ((reg_access_rs1 === post_alu_rd) || (reg_access_rs2 === post_alu_rd));

wire regaccess_blocked;
assign regaccess_blocked = regaccess_needs_alu_write || regaccess_needs_postalu_write;
// ---------

// -------- JALR jmp ctrl && branch
assign jmpctrl_en = reg_access_flags[10] || reg_access_flags[12];
//



always @(decoded_blocked or regaccess_blocked) begin
	fetch_en <= 1;
	decoded_latch_en <= 1;
	reg_access_latch_en <= 1;
	alu_latch_en <= 1;
	
	if(decoded_blocked) begin
		decoded_latch_en <= 0;
		fetch_en <= 0;
	end else 
		decoded_latch_en <= 1;
	
		
	if(regaccess_blocked) begin
		reg_access_latch_en <= 0;
		decoded_latch_en <= 0;
		fetch_en <= 0;
	end else
		reg_access_latch_en  <= 1;
		
end


endmodule