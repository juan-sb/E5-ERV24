module memory_mutator_latch(
 input rw,
 input sign,
 input [3:0] byte_en,
 input [1:0] access_size,
 
 input clk,
 input ena,
 input x,
 
 output reg rw_out,
 output reg sign_out,
 output reg [3:0] byte_en_out,
 output reg [1:0] access_size_out
);

always @(posedge clk) begin
	if (ena) begin
		 rw_out <= rw;
		 sign_out <= sign;
		 byte_en_out <= byte_en;
		 access_size_out <= access_size;
	end else begin
		 rw_out <= 0;
		 sign_out <= 0;
		 byte_en_out <= 0;
		 access_size_out <= 0;
	end
end
endmodule