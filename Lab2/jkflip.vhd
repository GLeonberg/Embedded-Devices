-- import logic primitives
library ieee;
use ieee.std_logic_1164.all;

entity jkflip is

	port (j, k, clk : in std_logic;
		    q, qbar : out std_logic);

end jkflip;

architecture behavioral of jkflip is
	signal qout : std_logic := '0';
	signal qbarout: std_logic := '1';
begin

	process(clk) is begin

		if rising_edge(clk) then

			if j = '1' and k = '0' then qout <=	'1';
			elsif j = '0' and k = '1' then qout <= '0';
			elsif j = '1' and k = '1' then qout <= not qout;
			else qout <= qout;
			end if;
	
		end if;

		q <= qout;
		qbar <= not qout;

	end process;

end behavioral;