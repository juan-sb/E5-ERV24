module uart_peripheral_2 #(
    parameter BAUD_RATE = 115200,
    parameter CLK_VAL_MHZ = 50
) (
    input wire clk,
    input wire rst,
    input wire enable,          // General enable
    input wire r_w,             // 1: read, 0: write
    input wire [3:0] byte_EN,   // Byte enable
    input wire [31:0] datain,   // Data input
    input wire addressin,			// Address input
    output reg [31:0] dataout,  // Data output
    output wire tx,
    input wire rx
);

    // Internal signals for control and status
    reg tx_enable, rx_enable;
    reg tx_reset, rx_reset;
    reg [7:0] tx_data;
    wire [7:0] rx_data;
    wire tx_ready, rx_ready;
    reg [7:0] control_reg; // Control and status register

    // Temporary registers to hold wire values
    reg tx_ready_reg, rx_ready_reg;

    // Instantiate the UART TX and RX modules
    uart_tx #(BAUD_RATE, CLK_VAL_MHZ) transmitter (
        .clk(clk),
        .rst(rst | tx_reset),
        .tx_data(tx_data),
        .tx_start(tx_enable),
        .tx_ready(tx_ready),
        .tx(tx)
    );
    
    uart_rx #(BAUD_RATE, CLK_VAL_MHZ) receiver (
        .clk(clk),
        .rst(rst | rx_reset),
        .rx(rx),
        .rx_data(rx_data),
        .rx_ready(rx_ready)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dataout <= 0;
            tx_data <= 0;
            tx_enable <= 0;
            rx_enable <= 0;
            tx_reset <= 0;
            rx_reset <= 0;
            control_reg <= 8'b00000000;
            tx_ready_reg <= 0;
            rx_ready_reg <= 0;
        end else if(enable) begin
            tx_ready_reg <= tx_ready; // Update temporary registers
            rx_ready_reg <= rx_ready; // Update temporary registers

            if (r_w) begin  // Read operation
					if(!addressin) begin
						case(byte_EN)
							4'b0010: dataout <= {24'b0, rx_data};
							4'b0100: dataout <= {24'b0, control_reg}; 
							4'b0110: dataout <= {26'b0, control_reg, rx_data}; 
							default: dataout <= 32'h0;
						endcase
					end
            end else begin  // Write operation
					if(!addressin) begin
						case(byte_EN)
							4'b0001: tx_data <= datain[7:0]; // Write Tx FIFO
							4'b0100: begin
								control_reg <= datain[7:0]; // Write control register
                        tx_enable <= datain[0];
                        rx_enable <= datain[1];
                        tx_reset <= datain[2];
                        rx_reset <= datain[3];
							end
							default: ;
						endcase
					end				
         
            end

            // Update control register with ready status
            control_reg[4] <= tx_ready_reg; // Tx ready status
            control_reg[5] <= rx_ready_reg; // Rx ready status
				
        end else begin
            tx_enable <= 0;
            rx_enable <= 0;
        end
    end

endmodule
