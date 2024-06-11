module GPIO_8bit (
	input wire address,
	input wire [3:0] byte_en,
	input wire [31:0] data,
	input wire rw,
	input wire clken,
	input wire clk,
	input wire nreset,
	output reg [31:0] q,
	inout wire[7:0] port
);


reg [7:0] PDOR;
reg [7:0] PSOR;
reg [7:0] PCOR;
reg [7:0] PTOR;
wire [7:0] PDIR;
reg [7:0] PDDR;
/*
localparam PDOR_addr = 10'b000; // Port Data Output Register
localparam PSOR_addr = 10'b001; // Port Set Output Register
localparam PCOR_addr = 10'b010; // Port Clear Output Register
localparam PTOR_addr = 10'b011; // Port Toggle Output Register
localparam PDIR_addr = 10'b100; // Port Data Input Register
localparam PDDR_addr = 10'b101; // Port Data Direction Register
*/
genvar i;
generate
	for(i=0; i < 8; i = i+1) begin : generation_block
		alt_iobuf io0 (.i(PDOR[i]), .oe(PDDR[i]), .o(PDIR[i]), .io(port[i]));
		defparam io0.io_standard = "3.3-V LVCMOS";
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

always @ (posedge clk or negedge nreset)
begin
	if(!nreset) begin
		PDOR = 0;
		PSOR = 0;
		PCOR = 0;
		PTOR = 0;
		PDDR = 0;
	end
	else if(clken) begin
		if(rw) begin
			if(address) q <= {16'b0, PDDR, PDIR};
			else q <= {24'b0, PDOR};
		end
		else begin
			if(address) begin
				case(byte_en)
					4'b1111: PDDR <= data[15:8];
					4'b0011: PDDR <= data[15:8];
					4'b0010: PDDR <= data[7:0];
					default: ;
				endcase
			end else begin
				case(byte_en)
					4'b1111: begin
						PDOR = data[7:0];
						PSOR = data[15:8];
						PCOR = data[23:16];
						PTOR = data[31:24];
					end
					4'b0011: begin
						PDOR = data[7:0];
						PSOR = data[15:8];
					end
					4'b1100: begin
						PCOR = data[7:0];
						PTOR = data[15:8];
					end
					4'b0001: PDOR = data[7:0];
					4'b0010: PSOR = data[7:0];
					4'b0100: PCOR = data[7:0];
					4'b1000: PTOR = data[7:0];
					default: ;
				endcase
			end
		end
	end
end


endmodule