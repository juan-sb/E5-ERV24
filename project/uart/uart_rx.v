module uart_rx #(parameter BAUD_RATE = 115200, parameter CLK_VAL_MHZ = 50) (
    input wire clk,
    input wire rst,
    input wire rx,
    output reg [7:0] rx_data,
    output reg rx_ready
);

    parameter BAUD_DIV = CLK_VAL_MHZ * 1000000 / BAUD_RATE; // Divisor para 115200 bps con un clock de 50MHz

    reg [3:0] bit_count;
    reg [12:0] baud_count;
    reg [9:0] shift_reg;
    reg sampling;
    reg [2:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rx_ready <= 1'b0;
            baud_count <= 0;
            bit_count <= 0;
            shift_reg <= 10'b1111111111;
            sampling <= 1'b0;
            state <= 0;
        end else begin
            case (state)
                0: begin // Waiting for start bit
                    if (~rx) begin
                        state <= 1;
                        baud_count <= 0;
                    end
                end
                1: begin // Sampling start bit
                    if (baud_count == (BAUD_DIV/2)) begin
                        baud_count <= 0;
                        if (~rx) begin
                            state <= 2;
                            bit_count <= 0;
                        end else begin
                            state <= 0;
                        end
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end
                2: begin // Sampling data bits
                    if (baud_count == BAUD_DIV) begin
                        baud_count <= 0;
                        shift_reg <= {rx, shift_reg[9:1]};
                        bit_count <= bit_count + 1;
                        if (bit_count == 8) begin
                            state <= 3;
                        end
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end
                3: begin // Stop bit
                    if (baud_count == BAUD_DIV) begin
                        baud_count <= 0;
                        state <= 0;
                        rx_data <= shift_reg[8:1];
                        rx_ready <= 1'b1;
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end
            endcase
        end
    end

endmodule
