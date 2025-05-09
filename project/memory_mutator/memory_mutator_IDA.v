module memory_mutator_IDA (
    input [1:0] access_size,
    input sign,
    input rw,
    input [31:0] rawaddress,
    input [31:0] data,
	 
    output reg [31:0] memadd,
    output reg [31:0] wrdata,
    output reg [3:0] byte_en,
	 output reg misaligned_flag,
	 output reg misaccess_flag
);
    
    always @(*) begin
        // Alineacion de dirección de memoria
        memadd = {rawaddress[31:2], 2'b00};
       
        byte_en = 4'b0000;
        wrdata = 32'b0;
		  misaligned_flag = 1'b0;
		  misaccess_flag = 1'b0;
        
        // Ajuste de datos y byte_en según el tamaño de acceso y desalineación
        case (access_size)
            2'b01: begin // 8 bits
                case (rawaddress[1:0])
                    2'b00: byte_en = 4'b0001;
                    2'b01: byte_en = 4'b0010;
                    2'b10: byte_en = 4'b0100;
                    2'b11: byte_en = 4'b1000;
                endcase
                
                if (!rw) begin // store (write)
						wrdata = {4{data[7:0]}};
//                    case (rawaddress[1:0])
//                        2'b00: wrdata = {24'b0, data[7:0]};
//                        2'b01: wrdata = {16'b0, data[7:0], 8'b0};
//                        2'b10: wrdata = {8'b0, data[7:0], 16'b0};
//                        2'b11: wrdata = {data[7:0], 24'b0};
//                    endcase
                end
            end
            
            2'b10: begin // 16 bits
                case (rawaddress[1:0])
                    2'b00: byte_en = 4'b0011;
						  2'b01: byte_en = 4'b0110;
                    2'b10: byte_en = 4'b1100;
                    default: misaligned_flag = 1'b1;
                endcase
                
                if (!rw) begin // store (write)
                    case (rawaddress[1:0])
                        2'b00: wrdata = {16'b0, data[15:0]};
								2'b01: wrdata = {8'b0, data[15:0], 8'b0};
                        2'b10: wrdata = {data[15:0], 16'b0};
								default: misaligned_flag = 1'b1;
                    endcase
                end
            end
            
            2'b11: begin // 32 bits
					 case (rawaddress[1:0])
                    2'b00: byte_en = 4'b1111;
                    default: misaligned_flag = 1'b1;
                endcase
                
                if (!rw) begin // store (write)
						 case (rawaddress[1:0])
							  2'b00: wrdata = data;
							  default: misaligned_flag = 1'b1;
						 endcase							
                    
                end
            end
            
            default: misaccess_flag = 1'b1;
        endcase
    end
    
endmodule
