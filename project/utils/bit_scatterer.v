module bit_scatterer #(parameter WIDTH=32)(
	input wire data,
	output wire [WIDTH-1:0] out
);

assign out = {{WIDTH{data}}};

endmodule