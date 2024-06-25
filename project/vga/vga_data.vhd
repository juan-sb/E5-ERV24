library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity vga_data is
	generic(
		px_width		:	integer	:=	800;	--	px
		px_height	:	integer	:=	600;	--	px
		r_depth		:	integer	:= 3;		--	bits
		g_depth		:	integer	:=	3;		--	bits
		b_depth		:	integer	:=	2		--	bits
		);
	port(
		i_en			:	in		std_logic;
		i_px_x		:	in		unsigned(9 downto 0);	--	horizontal read position
		i_px_y		:	in		unsigned(9 downto 0);	--	vertical read position
		
		i_color_fg	:	in		std_logic_vector((r_depth+g_depth+b_depth-1) downto 0);
		i_color_bg	:	in		std_logic_vector((r_depth+g_depth+b_depth-1) downto 0);
		
		i_icon_w		:	in		unsigned(5 downto 0);
		i_icon_x		:	in		unsigned(9 downto 0);
		
		i_icon_h		:	in		unsigned(5 downto 0);
		i_icon_y		:	in		unsigned(9 downto 0);
		
		o_r			:	out	std_logic_vector((r_depth-1) downto 0);
		o_g			:	out	std_logic_vector((g_depth-1) downto 0);
		o_b			:	out	std_logic_vector((b_depth-1) downto 0)
		);
end vga_data;

architecture behavior of vga_data is
begin
	process(i_en, i_px_x, i_px_y, i_icon_x, i_icon_y, i_icon_w, i_icon_h, i_color_fg, i_color_bg)
	begin
		if(i_en = '0') then
			o_r <= (others => '0');
			o_g <= (others => '0');
			o_b <= (others => '0');
		else
			if(i_px_x > i_icon_x and i_px_x < (i_icon_x + i_icon_w) and i_px_y > i_icon_y and i_px_y < (i_icon_y + i_icon_h)) then					--	px belongs to icon -> Foreground color
				o_r <= std_logic_vector(i_color_fg)(7 downto 5);
				o_g <= std_logic_vector(i_color_fg)(4 downto 2);
				o_b <= std_logic_vector(i_color_fg)(1 downto 0);
			else									--	px doesn't belong to icon -> Background color
				o_r <= std_logic_vector(i_color_bg)(7 downto 5);
				o_g <= std_logic_vector(i_color_bg)(4 downto 2);
				o_b <= std_logic_vector(i_color_bg)(1 downto 0);
			end if;
		end if;
	end process;
end behavior;