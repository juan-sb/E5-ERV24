LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use IEEE.math_real.all;

ENTITY vga_sync IS
	GENERIC(
		px_clk		:	INTEGER	:= 40000000;	-- Hz
		px_width		:	INTEGER	:= 800;			-- px
		px_height	:	INTEGER	:=	600;			--	px
		h_fp			:	INTEGER	:= 40;
		h_sp			:	INTEGER	:= 128;
		h_bp			:	INTEGER	:= 88;
		v_fp			:	INTEGER	:= 1;
		v_sp			:	INTEGER	:= 4;
		v_bp			:	INTEGER	:= 23
		);
	PORT(
		i_clk			:	IN		STD_LOGIC;							--	pixel clock
		i_reset_n	:	IN		STD_LOGIC;							--	asynchronous reset
		o_hsync		:	OUT	STD_LOGIC;							--	horizontal sync pulse
		o_vsync		:	OUT	STD_LOGIC;							--	vertical sync pulse
		o_disp_en	:	OUT	STD_LOGIC :=	'1';				--	'1' for color, '0' for blank
		o_x			:	OUT	STD_LOGIC_VECTOR(9 DOWNTO 0);	--	Horizontal coordinate
		o_y			:	OUT	STD_LOGIC_VECTOR(9 DOWNTO 0)	--	Vertical coordinate
		);
END vga_sync;

ARCHITECTURE Behavior OF vga_sync IS
	CONSTANT line_vis		: INTEGER := px_width;
	CONSTANT line_fp		: INTEGER := px_width + h_fp;
	CONSTANT line_sync	: INTEGER := px_width + h_fp + h_sp;
	CONSTANT line_end		: INTEGER := px_width + h_fp + h_sp + h_bp;
	CONSTANT frame_vis	: INTEGER := px_height;
	CONSTANT frame_fp		: INTEGER := px_height + v_fp;
	CONSTANT frame_sync	: INTEGER := px_height + v_fp + v_sp;
	CONSTANT frame_end	: INTEGER := px_height + v_fp + v_sp + v_bp;
BEGIN
	PROCESS(i_clk, i_reset_n)
		VARIABLE h_count	: INTEGER	RANGE 0 TO line_end - 1	:=	0;	-- Horizontal pixel counter
		VARIABLE v_count	: INTEGER	RANGE 0 TO frame_end- 1	:=	0;	-- Vertical pixel counter
	BEGIN
		IF(i_reset_n = '0') THEN
			h_count		:= 0;
			v_count		:= 0;
			o_hsync		<= '0';
			o_vsync		<= '0';
			o_disp_en	<= '0';
			
			o_x <= STD_LOGIC_VECTOR(to_unsigned(h_count, o_x'length));
			o_y <= STD_LOGIC_VECTOR(to_unsigned(v_count, o_y'length));
		ELSIF(i_clk'EVENT and i_clk = '1') THEN
			-- Avanzo contadores
			if(h_count < line_end - 1) then
				h_count := (h_count + 1);
			else
				h_count := 0;
				if(v_count < frame_end - 1) then
					v_count := (v_count + 1);
				else
					v_count := 0;
				end if;
			end if;
			
			-- Determinacion de hsync
			if(h_count < line_fp or h_count > line_sync) then
				o_hsync <= '1';
			else
				o_hsync <= '0';
			end if;
			
			--	Determinacion de vsync
			if(v_count < frame_fp or v_count > frame_sync) then
				o_vsync <= '1';
			else
				o_vsync <= '0';
			end if;
			
			--	Posicion de pixel
			if(h_count < line_vis) then
				o_x <= STD_LOGIC_VECTOR(to_unsigned(h_count, o_x'length));
			end if;
			
			if(v_count < frame_vis) then
				o_y <= STD_LOGIC_VECTOR(to_unsigned(v_count, o_y'length));
			end if;
			
			--	Determinacion de blanqueo
			IF	(h_count < line_vis and v_count < frame_vis) THEN
				o_disp_en <= '1';
			ELSE
				o_disp_en <= '0';
			END IF;
		END IF;
	END PROCESS;
END Behavior;