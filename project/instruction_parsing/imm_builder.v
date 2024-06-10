
module imm_builder(
	input wire[31:0] inst,
	input wire reset,
	output reg[31:0] imm
);


wire[4:0] opcode = inst[6:2];

always @* begin
    case(opcode)
		5'b01101, 5'b00101: begin					// Type U
			imm = {inst[31:12], 12'h000};
		end
		5'b11011: begin								// Type J
			imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
		end
		5'b11000: begin								// Type B
			imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
		end
		5'b01000: begin								// Type S
			imm = {{21{inst[31]}}, inst[30:25], inst[11:8], inst[7]};
		end
		5'b11001, 5'b00000: begin // Type I
			imm = {{21{inst[31]}}, inst[30:20]};
		end
		5'b00100: begin		// Type I, funct7 specs
			case(inst[14:12])
				3'b001, 3'b101: imm = {27'b0, inst[24:20]};
				default: imm = {{21{inst[31]}}, inst[30:20]};
			endcase
		end
		default: begin 	// Type R or invalid opcode
			imm = 32'h0000;
		end
    endcase
	 if (reset) begin
		imm = 32'h0000;
	 end
end

endmodule
