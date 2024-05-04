module GPIO #(parameter WIDTH=32)(
	input [9:0] address,
	input [WIDTH-1:0] data,
	input rden,
	input wren,
	input clken,
	input clk,
	input rst,
	output reg [WIDTH-1:0] q,
	inout wire[WIDTH-1:0] port
);

wire [WIDTH-1:0] in_port;
reg [WIDTH-1:0] out_port;
reg [WIDTH-1:0] oe_port;

localparam PDOR_addr = 10'b000; // Port Data Output Register
localparam PSOR_addr = 10'b001; // Port Set Output Register
localparam PCOR_addr = 10'b010; // Port Clear Output Register
localparam PTOR_addr = 10'b011; // Port Toggle Output Register
localparam PDIR_addr = 10'b100; // Port Data Input Register
localparam PDDR_addr = 10'b101; // Port Data Direction Register
genvar i;
generate
	for(i=0; i < WIDTH; i = i+1) begin : generation_block
		alt_iobuf io0 (.i(out_port[i]), .oe(oe_port[i]), .o(in_port[i]), .io(port[i]));
		defparam io0.io_standard = "3.3-V PCI";
		defparam io0.current_strength = "minimum current";
		// defparam io0.slow_slew_rate = "on";
		// defparam io0.location = "iobank_1";
	end
endgenerate
// alt_iobuf [WIDTH-1:0] port_iobufs (.i(out_port), .oe(oe_port), .o(in_port), .io(port));
/*
defparam my_iobuf.io_standard = "3.3-V PCI";
defparam my_iobuf.current_strength = "minimum current";
defparam my_iobuf.slow_slew_rate = "on";
defparam my_iobuf.location = "iobank_1";
*/

always @ (posedge clk or posedge rst)
begin
	if(rst) begin
		out_port = 0;
		oe_port = 0;
	end
	else if(clken) begin
		case(address)
			PDOR_addr: if(wren) out_port = data;
			PSOR_addr: if(wren) out_port = out_port | data;
			PCOR_addr: if(wren) out_port = out_port & (~data);
			PTOR_addr: if(wren) out_port = out_port ^ data;
			PDIR_addr: if(rden) q = in_port;
			PDDR_addr: begin
					if(wren) oe_port = data;
					if(rden) q = oe_port;
				end
			default: ;
		endcase
	end
end


endmodule