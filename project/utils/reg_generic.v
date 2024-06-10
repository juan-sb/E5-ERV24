module register #(parameter WIDTH=32)(
	input [WIDTH-1: 0] data,
	input clk,
	input nreset,
	input ena,
	output [WIDTH-1: 0] out
 );

	reg[WIDTH-1:0] q;
	wire reset;
	
	//assign reset = ~nreset;
 
	always @(posedge clk, negedge nreset) begin
		if (!nreset) begin
			q <= 0;
		end
		else if (clk && ena) begin
			q <= out;
		end
	end

	assign out = q;


endmodule