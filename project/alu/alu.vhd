library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
port(
	i_op	:	in		std_logic_vector(2 downto 0);
	i_sel	:	in		std_logic;
	i_branch	:	in		std_logic;
	i_jal :  in    std_logic;
	i_en	:	in		std_logic;
	i_a	:	in 	std_logic_vector(31 downto 0);
	i_b	:	in		std_logic_vector(31 downto 0);
	o_c	:	out	std_logic_vector(31 downto 0);
	o_n	:	out	std_logic := '0';
	o_z	:	out	std_logic := '0'
	);
end alu;

architecture behavioral of alu is
signal local_a, local_b, localsum : std_logic_vector(32 downto 0);

begin
	process(i_op,i_sel,i_en,i_a,i_b, i_branch, i_jal)
	variable ans	:	std_logic_vector(32 downto 0);
	begin
		if i_branch = '0' then
			case i_op is
			when	"000" =>	--	ADD / SUB
				if i_sel = '0' then
					ans := std_logic_vector(resize(signed(i_a), 33) + resize(signed(i_b), 33) );
				else
					ans := std_logic_vector(resize(signed(i_a), 33) - resize(signed(i_b), 33) );
				end if;
			when	"001" =>	--	SLL
				ans := std_logic_vector(shift_left( resize(unsigned(i_a), 33), to_integer(unsigned(i_b(4 downto 0))) ) );
			when	"010" => --	SLT
				if signed(i_a) < signed(i_b) then
					ans := "000000000000000000000000000000001";
				else
					ans := "000000000000000000000000000000000";
				end if;
			when	"011" => --	SLTU
				if unsigned(i_a) < unsigned(i_b) then
					ans := "000000000000000000000000000000001";
				else
					ans := "000000000000000000000000000000000";
				end if;
			when	"100" => --	XOR
				ans := std_logic_vector(resize(unsigned(i_a), 33) xor resize(unsigned(i_b), 33));
			when	"101" => --	SRL / SRA
				if i_sel = '0' then
					ans := std_logic_vector(shift_right(resize(unsigned(i_a), 33), to_integer(unsigned(i_b(4 downto 0))) ) );
				else
					ans := std_logic_vector(shift_right(resize(signed(i_a), 33), to_integer(unsigned(i_b(4 downto 0))) ) );
				end if;
			when	"110" => --	OR
				ans := std_logic_vector(resize(unsigned(i_a), 33) or resize(unsigned(i_b), 33));
			when	"111" =>	--	AND
				ans := std_logic_vector(resize(unsigned(i_a), 33) and resize(unsigned(i_b), 33));
			end case;
		else
			case i_op is
				when "000" | "001" | "100" | "101" => -- 000=BEQ, 001=BNE
					ans := std_logic_vector(resize(signed(i_a), 33) - resize(signed(i_b), 33));
				when "110" | "111" => -- BLTU < unsigned or BGEU >= unsigned
					ans := std_logic_vector(resize(unsigned(i_a), 33) - resize(unsigned(i_b), 33));
				when others =>
					ans := "000000000000000000000000000000000";
			end case;
		end if;
	if i_jal = '1' then
		ans := std_logic_vector(resize(unsigned(i_a), 33) + 4);
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
	
	if i_en = '0' then
		ans := "000000000000000000000000000000000";
	end if;
	o_c <= ans(31 downto 0);
	end process;
end behavioral;