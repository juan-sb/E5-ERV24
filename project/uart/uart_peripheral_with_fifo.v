module uart_peripheral_with_fifo #(
    parameter BAUD_RATE = 115200, 
    parameter CLK_VAL_MHZ = 50, 
    parameter FIFO_WIDTH = 8, 
    parameter FIFO_DEPTH = 16
) (
    input wire clk,
    input wire rst,
    input wire r_w,              // 1: read, 0: write
    input wire [3:0] byte_EN,    // Byte enable
    input wire [31:0] datain,    // Data input
    input wire [31:0] addressin,  // Address input (8 bits)
    output reg [31:0] dataout,   // Data output
    output wire tx,
    input wire rx
);

    // Internal signals for FIFO control and status
    reg tx_enable, rx_enable;
    reg tx_fifo_clear, rx_fifo_clear;

    reg [7:0] tx_data;
    wire [7:0] rx_data;

    reg tx_ready;
    wire tx_ready_wire;

    assign tx_ready = tx_ready_wire;
    
    assign tx_ready = tx_ready_wire;

    // Instantiate the UART TX FIFO module
    uart_tx_with_fifo #(BAUD_RATE, CLK_VAL_MHZ) tx_fifo(
        .clk(clk),
        .rst(rst),
        .tx_data(tx_data),
        .tx_wr_en(tx_enable && !r_w && (addressin == 8'h00)),
        .tx_ready(tx_ready_wire),
        .tx(tx),
        .clear(tx_fifo_clear)
    );

    // Instantiate the UART RX FIFO module
    uart_rx_with_fifo #(BAUD_RATE, CLK_VAL_MHZ) rx_fifo(
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_data(rx_data),
        .rx_ready(rx_ready),
        .clear(rx_fifo_clear)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dataout <= 0;
            tx_enable <= 1'b0;
            rx_enable <= 1'b0;
            tx_fifo_clear <= 1'b0;
            rx_fifo_clear <= 1'b0;
        end else begin
            if (r_w) begin  // Read operation
                case (addressin)
                    8'h01: dataout <= {24'b0, rx_data};      // Read Rx FIFO
                    8'h02: dataout <= {26'b0, rx_ready, tx_ready, 1'b0, 1'b0, rx_enable, tx_enable}; // Read flags
                    default: dataout <= 32'h0;
                endcase
            end else begin   // Write operation
                case (addressin)
                    8'h00: tx_data <= datain[7:0];           // Write Tx FIFO
                    8'h02: begin                             // Enable Tx and Rx
                        tx_enable <= datain[0];
                        rx_enable <= datain[1];
                        tx_fifo_clear <= datain[2];
                        rx_fifo_clear <= datain[3];
                        tx_ready <= datain[4];
                        rx_ready <= datain[5];
                    end
                endcase
            end
        end
    end

endmodule
