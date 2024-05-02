module TestPeripheral1 (
	input [10:0] address,
	input [31:0] data,
	input rden,
	input wren,
	input clken,
	input clk,
	output reg [31:0] q,
	output wire P0
);

reg [31:0] porta;
wire enabled_clk = clk & clken;

always @ (posedge clk)
begin
	if(enabled_clk)
	begin
		if(address == 11'h000 && wren)
			porta = data;
		if(address == 11'h000 && rden)
			q = porta;
	end
end

assign P0 = porta[0];

endmodule