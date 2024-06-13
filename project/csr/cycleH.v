module cycleH_reg
(
 input[31:0] d,
 input clk,
 input nreset,
 input en_rw,
 input [1:0] rw_mode,
 input carry,
 output [31:0] qo
 );

	reg[31:0] q;
 
	always @(posedge clk, negedge nreset) begin
		if (!nreset) begin
			q <= 1;
		end
		/*else if (rw_mode == 2'b01) begin
			q <= d;									// CSRRW
		end
		else if (rw_mode == 2'b10) begin
			q <= q | d;								// CSRRS
		end
		else if (rw_mode == 2'b11) begin
			q <= q & d;								// CSRRC
		end*/
		else if (carry ^ !q[0]) begin
			q <= q + 1;
		end
	end

	assign qo = q - 1;


endmodule