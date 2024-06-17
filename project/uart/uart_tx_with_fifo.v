module uart_tx_with_fifo #(parameter BAUD_RATE = 115200, parameter CLK_VAL_MHZ = 50, parameter FIFO_WIDTH = 8, parameter FIFO_DEPTH = 16) (
    input wire clk,
    input wire rst,
    input wire [7:0] tx_data,
    input wire tx_wr_en,
    output wire tx_ready,
    output wire tx
);

    wire fifo_empty;
    wire [7:0] fifo_data_out;
    reg tx_start;
    wire fifo_rd_en;

    fifo #(FIFO_WIDTH, FIFO_DEPTH) tx_fifo (
        .clk(clk),
        .rst(rst),
        .wr_en(tx_wr_en),
        .rd_en(fifo_rd_en),
        .din(tx_data),
        .dout(fifo_data_out),
        .full(),
        .empty(fifo_empty)
    );

    uart_tx #(BAUD_RATE, CLK_VAL_MHZ) transmitter (
        .clk(clk),
        .rst(rst),
        .tx_data(fifo_data_out),
        .tx_start(tx_start),
        .tx_ready(tx_ready),
        .tx(tx)
    );

    assign fifo_rd_en = tx_ready && !fifo_empty;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_start <= 0;
        end else begin
            if (fifo_rd_en) begin
                tx_start <= 1;
            end else begin
                tx_start <= 0;
            end
        end
    end

endmodule
