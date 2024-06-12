
module csr_handler(
	input clk,
	input nreset,
	input[2:0] funct3,
	input[11:0] CSR_add,
	input[4:0] rs1,				// Para catchear los casos de rs1 == 0
	input[4:0] rd,					// Para catchear los casos de rd == 0
	output[3:0] csr_sel,			// Selector para los 16 csr implementados
	output reg[1:0] rw_mode,	// Modo de lectura/escritura (read: b00, read/write: b01, read/set: b10, read/clear: b11)
	output reg csr_rd				// Flag de lectura (hay ciertos casos con rs1/rd == 0 en los que no se debe leer el csr). 
										// Se incluyó por completitud, pero no está implementado el caso de escritura sin lectura en el banco de registros CSR.
										// !! Debera ser implementado si se incluye un CSR que cambia al ser leido.
);

// Transformamos el address para que se ajuste a los CSRs que implementamos (C00-C02 y C80-C82) -> (0-2 y 8-A).
// Se puede alterar para considerar otros address para los CSR genericos.
assign csr_sel = {CSR_add[7], CSR_add[2:0]};		

always @(posedge clk, negedge nreset) begin
	if (!nreset) begin
		rw_mode <= 2'b00;
		csr_rd <= 1'b0;
		end
	else if (rs1 == 5'b00000 && funct3[1]) begin
		rw_mode <= 2'b00;
		csr_rd <= 1'b1;
	end
	else if (rd == 5'b00000 && !funct3[1] && funct3[0]) begin
		rw_mode <= funct3[1:0];
		csr_rd <= 1'b0;
	end
	else begin
		rw_mode <= funct3[1:0];
		csr_rd <= 1'b1;
	end
end

endmodule