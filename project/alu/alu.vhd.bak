library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
port(
	i_op	:	in		std_logic_vector(2 downto 0);
	i_sel	:	in		std_logic;
	i_jmp	:	in		std_logic;
	i_a	:	in 	std_logic_vector(31 downto 0);
	i_b	:	in		std_logic_vector(31 downto 0);
	o_c	:	out	std_logic_vector(31 downto 0);
	o_n	:	out	std_logic := '0';
	o_z	:	out	std_logic := '0'
	);
end alu;

architecture behavioral of alu is
begin
	process(i_op,i_sel,i_a,i_b, i_jmp)
	variable ans	:	std_logic_vector(31 downto 0);
	begin
		if i_jmp = '0' then
			case i_op is
			when	"000" =>	--	ADD / SUB
				if i_sel = '0' then
					ans := std_logic_vector(signed(i_a) + signed(i_b) );
				else
					ans := std_logic_vector(signed(i_a) - signed(i_b) );
				end if;
			when	"001" =>	--	SLL
				ans := std_logic_vector(shift_left( unsigned(i_a), to_integer(unsigned(i_b(4 downto 0))) ) );
			when	"010" => --	SLT
				if signed(i_a) < signed(i_b) then
					ans := "00000000000000000000000000000001";
				else
					ans := "00000000000000000000000000000000";
				end if;
			when	"011" => --	SLTU
				if unsigned(i_a) < unsigned(i_b) then
					ans := "00000000000000000000000000000001";
				else
					ans := "00000000000000000000000000000000";
				end if;
			when	"100" => --	XOR
				ans := i_a xor i_b;
			when	"101" => --	SRL / SRA
				if i_sel = '0' then
					ans := std_logic_vector(shift_right( unsigned(i_a), to_integer(unsigned(i_b(4 downto 0))) ) );
				else
					ans := std_logic_vector(shift_right( signed(i_a), to_integer(unsigned(i_b(4 downto 0))) ) );
				end if;
			when	"110" => --	OR
				ans := i_a or i_b;
			when	"111" =>	--	AND
				ans := i_a and i_b;
			end case;
		else
			ans := std_logic_vector(signed(i_a) - signed(i_b) );
		end if;
	
	if unsigned(ans) = 0 then
		o_z <= '1';
	else
		o_z <= '0';
	end if;
	if signed(ans) < 0 then
		o_n <= '1';
	else
		o_n <= '0';
	end if;
	o_c <= ans;
	end process;
end behavioral;