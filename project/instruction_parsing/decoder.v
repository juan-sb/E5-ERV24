module decoder(
	input wire[31:0] inst,
	input wire nreset,					// Pone todas las salidas en 0
	output wire[4:0] rd,
	output wire[4:0] rs1,
	output wire[4:0] rs2,
	output wire[2:0] funct3,
	output reg rd_enc,				// Habilita que el valor del bus C se guarde en el registro rd
	output reg rs1_ena,				// Habilita que el valor del registro rs1 se copie al bus A
	output reg rs2_enb,				// Habilita que el valor del registro rs2 se copie al bus B
	output reg imm_en,				// Habilita el calculo de imm y su copia al bus IMM
	//output reg imm_enb,				// Habilita que el valor del imm se copie al bus B
	//output reg pc_ena, 				// Habilita que el valor del PC se copie al bus A
	output reg ALU_en,				// Habilita la ALU
	output reg ALU_flag,			// Flag para ciertas operaciones de la ALU
	output reg mem_en,				// Habilita el acceso a memoria
	output wire rw,					// Indica si el acceso a memoria es de lectura(1) o escritura(0)
	output wire is_jmp,
	output reg is_jalr,
	output reg is_jal,
	output reg is_branch,
	output reg is_fence,
	output reg is_system,
	output reg is_invalid,
	output wire unsign,					// Indica si la lectura de memoria es signada o no
	output wire[1:0] access_size	// Indica la cantidad de bytes del acceso a memoria
);

wire is_reset = !nreset || (inst == 32'h13); // NOP = addi x0, x0, 0
wire[4:0] opcode = inst[6:2];
assign rd = is_reset ? 5'b0 : inst[11:7];
assign funct3 = is_reset ? 3'b0 : inst[14:12];
assign rs1 = is_reset || (opcode[3] && opcode[2] && opcode[0]) ? 5'b0 : inst[19:15];	// LUI requiere rs1 = 0
assign rs2 = is_reset ? 5'b0 : inst[24:20];
assign rw = is_reset ? 1'b0 : !inst[5];				// rw = 0 si es STORE, = 1 si es LOAD
assign unsign = is_reset ? 1'b0 : inst[14];		// unsign = 1 si LBU o LHU
assign access_size = is_reset ? 2'b0 : inst[13:12] + 1;
assign is_jmp = is_jalr || is_jal || is_branch;

always @(is_reset, opcode)
begin
	if(is_reset) begin
		is_invalid = 1'b0;
		rd_enc = 1'b0;
		rs1_ena = 1'b0;
		rs2_enb = 1'b0;
		imm_en = 1'b0;
		//imm_enb = 1'b0;
		//pc_ena = 1'b0;
		ALU_flag = 0;
		ALU_en = 1'b0;
		is_jal = 1'b0;
		is_jalr = 1'b0;
		is_branch = 1'b0;
		mem_en = 1'b0;
		is_fence = 1'b0;
		is_system = 1'b0;
	end else
	case(opcode)
		// LUI (U) o AIUPC(U)
		5'b01101, 5'b00101: begin
			ALU_en = 1'b1;
			rd_enc = 1'b1;				  
			rs1_ena = opcode[3];		// rd = 0 + imm si el LUI
			//pc_ena = !opcode[3]; 	// rd = PC + imm si es AIUPC
			imm_en = 1'b1;
			//imm_enb = 1'b1;
			rs2_enb = 1'b0;
			ALU_flag = 0;
			mem_en = 1'b0;
			is_jal = 1'b0;
			is_jalr = 1'b0;
			is_branch = 1'b0;
			is_fence = 1'b0;
			is_system = 1'b0;
			is_invalid = 1'b0;
		end
		// JAL (J), JALR (I) o BRANCH (B)
		5'b11011, 5'b11001, 5'b11000: begin	
			is_jal = opcode[1] && opcode[0];	
			is_jalr = !opcode[1] && opcode[0];
			is_branch = !(opcode[1] || opcode[0]);
			imm_en = 1'b1;				// El imm no va la ALU sino al Add Builder por el bus IMM
			rs1_ena = !opcode[1];	// El rs1 va al Add Builder ya que add = rs1 + imm en JALR y BRANCH, pero si es BRANCH rs1 también tiene que ir a la ALU
			ALU_en = !opcode[0];		// ALU_en = 1 si es BRANCH, va a ejecutar un SUB xq jmp_en = 1
			rs2_enb = !opcode[0];	// rs2_enb = 1 si es BRANCH
			rd_enc = opcode[0]; 		// rd_enc = 1 si es JAL o JALR
			//imm_enb = 1'b0;
			//pc_ena = opcode[1];	// El PC va al Add Builder si es JAL
			mem_en = 1'b0;
			ALU_flag = 0;
			is_fence = 1'b0;
			is_system = 1'b0;
			is_invalid = 1'b0;
		end
		//  LOAD (I) o STORE (S)
		5'b00000, 5'b01000: begin	
			mem_en = 1'b1;
			rs1_ena = 1'b1;			// El rs1 va al Add Builder ya que add = rs1 + imm en LOAD y STORE
			imm_en = 1'b1;				// El imm va al Add Builder con el bus IMM
			rs2_enb = opcode[3];		// El rs2 va al Memory Mutator si es STORE
			rd_enc = !opcode[3];		// rd_enc = 1 si es LOAD
			//imm_enb = 1'b0;
			//pc_ena = 1'b0;
			ALU_flag = 0;
			ALU_en = 1'b0;
			is_jal = 1'b0;
			is_jalr = 1'b0;
			is_branch = 1'b0;
			is_fence = 1'b0;
			is_system = 1'b0;
			is_invalid = 1'b0;
		end
		// ALUI (I) o ALU (R)
		5'b00100, 5'b01100: begin
			ALU_en = 1'b1;
			rd_enc = 1'b1;
			rs1_ena = 1'b1;
			rs2_enb = opcode[3];		// rs2_enb = 1 si es ALU, = 0 si es ALUI
			imm_en = !opcode[3];
			//imm_enb = !opcode[3]; 	// imm_enb = 1 si es ALUI, = 0 si es ALU
			//pc_ena = 1'b0;
			mem_en = 1'b0;
			is_jal = 1'b0;
			is_jalr = 1'b0;
			is_branch = 1'b0;
			is_fence = 1'b0;
			is_system = 1'b0;
			is_invalid = 1'b0;
			if(opcode == 5'b00100)
				case(funct3)
					3'b000, 3'b010, 3'b011, 3'b100, 3'b110, 3'b111: ALU_flag = 0;
					default: ALU_flag = inst[30];
				endcase
			else
				ALU_flag = inst[30];
		end
		// FENCE (R) or SYSTEM (R)
		5'b00011, 5'b11100: begin		
			is_fence = opcode[0];	
			is_system = opcode[4];
			rd_enc = 1'b0;
			rs1_ena = 1'b0;
			rs2_enb = 1'b0;
			imm_en = 1'b0;
			//pc_ena = 1'b0;
			//imm_enb = 1'b0;
			ALU_en = 1'b0;
			ALU_flag = inst[30];
			mem_en = 1'b0;
			is_jal = 1'b0;
			is_jalr = 1'b0;
			is_branch = 1'b0;
			is_invalid = 1'b0;
		end
		default: begin 	// Invalid opcode
			is_invalid = 1'b1;
			rd_enc = 1'b0;
			rs1_ena = 1'b0;
			rs2_enb = 1'b0;
			imm_en = 1'b0;
			//imm_enb = 1'b0;
			//pc_ena = 1'b0;
			ALU_en = 1'b0;
			ALU_flag = 0;
			mem_en = 1'b0;
			is_jal = 1'b0;
			is_jalr = 1'b0;
			is_branch = 1'b0;
			is_fence = 1'b0;
			is_system = 1'b0;
		end
	endcase
end

endmodule