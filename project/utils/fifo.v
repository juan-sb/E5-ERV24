module fifo #(parameter WIDTH = 8, parameter DEPTH = 16) (
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout,
    output reg full,
    output reg empty
);

    reg [WIDTH-1:0] fifo_mem [0:DEPTH-1];
    reg [4:0] wr_ptr;
    reg [4:0] rd_ptr;
    reg [4:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (wr_en && !full) begin
                fifo_mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
                if (wr_ptr == DEPTH-1) begin
                    wr_ptr <= 0;
                end
            end
            if (rd_en && !empty) begin
                dout <= fifo_mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
                if (rd_ptr == DEPTH-1) begin
                    rd_ptr <= 0;
                end
            end
            full <= (count == DEPTH);
            empty <= (count == 0);
        end
    end

endmodule
