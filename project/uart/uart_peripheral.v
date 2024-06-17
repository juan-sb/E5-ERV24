module uart_peripheral #(parameter BAUD_RATE = 115200, CLK_VAL_MHZ = 50)(
    input wire clk,
    input wire rst,
    input wire r_w,             // 1: read, 0: write
    input wire [3:0] byte_EN,   // Byte enable
    input wire [31:0] datain,   // Data input
    input wire [31:0] addressin,// Address input
    output reg [31:0] dataout,  // Data output
    output wire tx,
    input wire rx
);

    wire tx_ready, rx_ready;
    reg tx_start;
    reg [7:0] tx_data;
    wire [7:0] rx_data;
    
    uart_tx #(BAUD_RATE, CLK_VAL_MHZ) transmitter(
        .clk(clk),
        .rst(rst),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx_ready(tx_ready),
        .tx(tx)
    );
    
    uart_rx #(BAUD_RATE, CLK_VAL_MHZ) receiver(
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_data(rx_data),
        .rx_ready(rx_ready)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dataout <= 0;
            tx_data <= 0;
            tx_start <= 0;
        end else begin
            if (!r_w) begin  // Write operation
                if (addressin == 32'h00000000) begin
                    tx_data <= datain[7:0];
                    tx_start <= 1;
                end
            end else begin   // Read operation
                if (addressin == 32'h00000000) begin
                    dataout <= {24'b0, rx_data};
                end
            end

            if (tx_ready) begin
                tx_start <= 0;
            end
        end
    end

endmodule
