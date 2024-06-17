module uart_rx_with_fifo #(parameter BAUD_RATE = 115200, parameter CLK_VAL_MHZ = 50, parameter FIFO_WIDTH = 8, parameter FIFO_DEPTH = 16) (
    input wire clk,
    input wire rst,
    input wire rx,
    output wire [7:0] rx_data,
    output wire rx_ready
);

    wire fifo_full;
    wire [7:0] rx_data_internal;
    wire fifo_wr_en;

    fifo #(FIFO_WIDTH, FIFO_DEPTH) rx_fifo (
        .clk(clk),
        .rst(rst),
        .wr_en(fifo_wr_en),
        .rd_en(rx_ready),
        .din(rx_data_internal),
        .dout(rx_data),
        .full(fifo_full),
        .empty()
    );

    uart_rx #(BAUD_RATE, CLK_VAL_MHZ) receiver (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_data(rx_data_internal),
        .rx_ready(fifo_wr_en)
    );

    assign fifo_wr_en = !fifo_full && receiver.rx_ready;

endmodule
