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
		i_rx			:	in		std_logic_vector(9 downto 0);	--	horizontal read position
		i_ry			:	in		std_logic_vector(9 downto 0);	--	vertical read position
		
		i_ctrl		:	in		std_logic_vector(7 downto 0);	--	VGA Test Pattern Controller
		
		o_r			:	out	std_logic_vector((r_depth-1) downto 0);
		o_g			:	out	std_logic_vector((g_depth-1) downto 0);
		o_b			:	out	std_logic_vector((b_depth-1) downto 0)
		);
end vga_data;

architecture behavior of vga_data is
begin
	process(i_en, i_rx, i_ry, i_ctrl)
	begin
		if(i_en = '0') then
			o_r <= (others => '0');
			o_g <= (others => '0');
			o_b <= (others => '0');
		else
			o_r <= i_ctrl(7 downto 5);
			o_g <= i_ctrl(4 downto 2);
			o_b <= i_ctrl(1 downto 0);
		end if;
	end process;
end behavior;