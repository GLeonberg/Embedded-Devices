-- Import logic primitives
library ieee;
use ieee.std_logic_1164.all;

-- Decodes 4 bit input into hex, drives it across all hex displays on board
entity part2 is

port  ( SW: in std_logic_vector(3 downto 0); -- 4 switches as binary input to decode
        HEX0: out std_logic_vector(6 downto 0);
	HEX1: out std_logic_vector(6 downto 0);
	HEX2: out std_logic_vector(6 downto 0);
	HEX3: out std_logic_vector(6 downto 0);
	HEX4: out std_logic_vector(6 downto 0);
	HEX5: out std_logic_vector(6 downto 0);
	HEX6: out std_logic_vector(6 downto 0);
	HEX7: out std_logic_vector(6 downto 0) );

end part2;

architecture decode of part2 is
signal hex : std_logic_vector(6 downto 0); -- intermediate signal
begin

	process (SW, hex) is
	begin
	
		case SW is 

			when "0000" => hex <= "1000000"; -- 0
			when "0001" => hex <= "1111001"; -- 1
			when "0010" => hex <= "0100100"; -- 2
			when "0011" => hex <= "0110000"; -- 3
			when "0100" => hex <= "0011001"; -- 4
			when "0101" => hex <= "0010010"; -- 5
			when "0110" => hex <= "0000010"; -- 6
			when "0111" => hex <= "1111000"; -- 7
			when "1000" => hex <= "0000000"; -- 8
			when "1001" => hex <= "0011000"; -- 9
			when "1010" => hex <= "0001000"; -- A
			when "1011" => hex <= "0000011"; -- b
			when "1100" => hex <= "0100111"; -- c
			when "1101" => hex <= "0100001"; -- d
			when "1110" => hex <= "0000110"; -- E
			when "1111" => hex <= "0001110"; -- F
			when others => hex <= "1111111"; -- null

		end case;

		-- Drive signal to hex displays (Active low)
		
		HEX0 <= hex;
		HEX1 <= hex;
		HEX2 <= hex;
		HEX3 <= hex;
		HEX4 <= hex;
		HEX5 <= hex;
		HEX6 <= hex;
		HEX7 <= hex;
		
	end process;

end decode;
