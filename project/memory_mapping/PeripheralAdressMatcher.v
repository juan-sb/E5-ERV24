module PeripheralAddressMatcher(
	input wire [31:0] address,
	output wire match,
	output wire error
);


assign match = ~(address[28] & (|address[31:29]) & (|address[27:24]));
assign error = address[28] & ~match;

endmodule