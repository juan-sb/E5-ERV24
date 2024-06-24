module uart_tx #(parameter BAUD_RATE = 115200, parameter CLK_VAL_MHZ = 50)(
    input wire clk,
    input wire rst,
    input wire [7:0] tx_data,
    input wire tx_start,
    output reg tx_ready,
    output reg tx
);

    parameter BAUD_DIV = CLK_VAL_MHZ * 1000000 / BAUD_RATE; // Divisor para 115200 bps con un clock de 50MHz

    reg [3:0] bit_count;
    reg [12:0] baud_count;
    reg [9:0] shift_reg;
    reg transmitting;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1'b1;
            tx_ready <= 1'b1;
            baud_count <= 0;
            bit_count <= 0;
            shift_reg <= 10'b1111111111;
            transmitting <= 1'b0;
        end else begin
            if (tx_start && tx_ready) begin
                tx_ready <= 1'b0;
                shift_reg <= {1'b1, tx_data, 1'b0}; // Start bit (0), 8 data bits, Stop bit (1)
                bit_count <= 0;
                transmitting <= 1'b1;
            end
            
            if (transmitting) begin
                if (baud_count == BAUD_DIV) begin
                    baud_count <= 0;
                    tx <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;
                    bit_count <= bit_count + 1;

                    if (bit_count == 10) begin
                        tx_ready <= 1'b1;
                        tx <= 1'b1;
                        transmitting <= 1'b0;
                    end
                end else begin
                    baud_count <= baud_count + 1;
                end
            end
        end
    end

endmodule
