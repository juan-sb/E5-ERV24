module vga_peripheral_adapter (
    input wire [31:0] data,
    input wire address,
    input wire [3:0] byte_en,
    input wire rw,        // 1: read, 0: write
    input wire clken,
    input wire clk,
    input wire nreset,
    
    // hacia vga_data
    output reg [7:0] color_fg,  // 3+3+2 bits
    output reg [7:0] color_bg,  // 3+3+2 bits
    output reg [5:0] icon_w,
    output reg [9:0] icon_x,
    output reg [5:0] icon_h,
    output reg [9:0] icon_y,
	 
	 output reg [31:0] q
);

// Local parameters for register addresses (byte addresses)
// localparam COLOR_FG_ADDR = 32'h00;
// localparam COLOR_BG_ADDR = 32'h01;
// localparam ICON_WX_ADDR = 32'h02;
// localparam ICON_HY_ADDR = 32'h04;

// Registers to hold the values
reg [7:0] color_fg_reg;
reg [7:0] color_bg_reg;
reg [15:0] icon_wx_reg;
reg [15:0] icon_hy_reg;

always @(posedge clk or negedge nreset) begin
    if (!nreset) begin
        color_fg_reg <= 8'b0;
        color_bg_reg <= 8'b0;
        icon_wx_reg <= 16'b0;
        icon_hy_reg <= 16'b0;
    end else if (clken) begin
        if (!rw) begin // Write operation
				if(!address) begin
					case(byte_en)
						4'b1111: begin
							color_fg_reg <= data[7:0];
							color_bg_reg <= data[15:8];
							icon_wx_reg <= data[31:16];
						end
						4'b0011: begin
							color_fg_reg <= data[7:0];
							color_bg_reg <= data[15:8];
						end
						4'b0001: color_fg_reg <= data[7:0];
						4'b0010: color_bg_reg <= data[7:0];
						4'b1100: icon_wx_reg <= data[15:0];
						default: ;
					endcase
				end else begin
					case(byte_en)
						4'b0011: icon_hy_reg <= data[15:0];
						default: ;
					endcase
				end
        end
		  else begin	// Read operation
				if(!address) begin
					case(byte_en)
						4'b1111: q <= {icon_wx_reg, color_bg_reg, color_fg_reg};
						4'b0001: q <= {24'b0, color_fg_reg};
						4'b0010: q <= {24'b0, color_bg_reg};
						4'b0011: q <= {16'b0, color_bg_reg, color_fg_reg};
						4'b1100: q <= {16'b0, icon_wx_reg};
						4'b0001: q <= {24'b0, icon_wx_reg[7:0]};
						4'b0010: q <= {24'b0, icon_wx_reg[15:8]};
						default: q <= {32'b0};
					endcase
				end else begin
					case(byte_en)
						4'b0011: q <= {16'b0, icon_hy_reg};
						4'b0001: q <= {24'b0, icon_hy_reg[7:0]};
						4'b0010: q <= {24'b0, icon_hy_reg[15:8]};
						default: q <= {32'b0};
					endcase
				end
		  end
    end
end

// Assign output registers to the module outputs
always @(*) begin
    color_fg = color_fg_reg;	
    color_bg = color_bg_reg;
    icon_w = icon_wx_reg[15:10];
    icon_x = icon_wx_reg[9:0];
    icon_h = icon_hy_reg[15:10];
    icon_y = icon_hy_reg[9:0];
end

endmodule
