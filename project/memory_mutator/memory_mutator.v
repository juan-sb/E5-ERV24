module memory_mutator(
	input wire[31:0] data,
	input wire[2:0] command,
	output reg[31:0] q
);


always @(*)
begin
	case(command)
	 3'b000: begin
		q = data;
	 end
	 
	 3'b001: begin
		q = 0;
	 end
	 
	 3'b010: begin
		q = {16'b0, data[15:0]};
	 end
	 
	 3'b011: begin
		q = {16'b0, data[31:16]};
		
	 end
	 
	 3'b100: begin
		q = {24'b0, data[7:0]};
	 end
	 
	 3'b101: begin
		q = {24'b0, data[15:8]};
	 end
	 
	 3'b110: begin
		q = {24'b0, data[23:16]};
	 end
	 
	 3'b111: begin
		q = {24'b0, data[31:24]};
	 end
	endcase
end

endmodule
