module memory_mutator_VUELTA (
    input rw,
    input sign,
    input [3:0] byte_en,
    input [31:0] rddata,
    input [1:0] access_size,
	 
    output reg [31:0] adjusted_data,
    output reg misaligned_flag,
    output reg misaccess_flag
);
    
    always @(*) begin
        adjusted_data = 32'b0;
        misaligned_flag = 1'b0;
        misaccess_flag = 1'b0;
        
        if (rw) begin // load (read)
            case (access_size)
                2'b01: begin // 8 bits
                    case (byte_en)
                        4'b0001: adjusted_data = sign ? {{24{rddata[7]}}, rddata[7:0]} : {24'b0, rddata[7:0]};
                        4'b0010: adjusted_data = sign ? {{24{rddata[15]}}, rddata[15:8]} : {24'b0, rddata[15:8]};
                        4'b0100: adjusted_data = sign ? {{24{rddata[23]}}, rddata[23:16]} : {24'b0, rddata[23:16]};
                        4'b1000: adjusted_data = sign ? {{24{rddata[31]}}, rddata[31:24]} : {24'b0, rddata[31:24]};
                        default: misaligned_flag = 1'b1;
                    endcase
                end
                
                2'b10: begin // 16 bits
                    case (byte_en)
                        4'b0011: adjusted_data = sign ? {{16{rddata[15]}}, rddata[15:0]} : {16'b0, rddata[15:0]};
								4'b0110: adjusted_data = sign ? {{16{rddata[23]}}, rddata[23:8]} : {16'b0, rddata[23:8]};
                        4'b1100: adjusted_data = sign ? {{16{rddata[31]}}, rddata[31:16]} : {16'b0, rddata[31:16]};
                        default: misaligned_flag = 1'b1;
                    endcase
                end
                
                2'b11: begin // 32 bits
                    if (byte_en == 4'b1111) adjusted_data = rddata;
                    else misaligned_flag = 1'b1;
                end
                
                default: misaccess_flag = 1'b1;
            endcase
        end
    end
    
endmodule
