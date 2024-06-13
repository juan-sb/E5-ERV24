module csr_reg
(
 input[31:0] d,
 input clk,
 input nreset,
 input en_rw,
 input[1:0] rw_mode,
 output[31:0] qo
 );

	reg[31:0] q;
	//reg[31:0] aux;
 
	always @(posedge clk, negedge nreset) begin
		if (!nreset) begin
			q <= 0;
			//aux <= 0;
		end
		else if (en_rw && (rw_mode == 2'b01)) begin
			//aux <= q;
			q <= d;									// CSRRW
		end
		else if (en_rw && (rw_mode == 2'b10)) begin
			//aux <= q;
			q <= q | d;								// CSRRS
		end
		else if (en_rw && (rw_mode == 2'b11)) begin
			//aux <= q;
			q <= q & d;								// CSRRC
		end
		else begin
			//aux <= q;
			// Lo que sea que haga el CSR
		end
	end

	//assign qo = aux;
	assign qo = q;
	
endmodule