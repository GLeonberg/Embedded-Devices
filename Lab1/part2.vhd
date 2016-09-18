-- Import logic primitives
library ieee;
use ieee.std_logic_1164.all;

-- Combine 7seg and decoder into 1 entity
entity part2 is

port  ( SW: in std_logic_vector(3 downto 0);
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
signal hex : std_logic_vector(6 downto 0);
begin

	process (SW, hex) is
	begin
	
		case SW is 

			when "0000" => hex <= "0111111"; -- 0
			when "0001" => hex <= "0000110"; -- 1
			when "0010" => hex <= "1011011"; -- 2
			when "0011" => hex <= "1001111"; -- 3
			when "0100" => hex <= "1100110"; -- 4
			when "0101" => hex <= "1101101"; -- 5
			when "0110" => hex <= "1111101"; -- 6
			when "0111" => hex <= "0000111"; -- 7
			when "1000" => hex <= "1111111"; -- 8
			when "1001" => hex <= "1100111"; -- 9
			when "1010" => hex <= "1110111"; -- A
			when "1011" => hex <= "1111100"; -- b
			when "1100" => hex <= "1011000"; -- c
			when "1101" => hex <= "1011110"; -- d
			when "1110" => hex <= "1111001"; -- E
			when "1111" => hex <= "1110001"; -- F
			when others => hex <= "0000000"; -- null

		end case;

		HEX0 <= not hex;
		HEX1 <= not hex;
		HEX2 <= not hex;
		HEX3 <= not hex;
		HEX4 <= not hex;
		HEX5 <= not hex;
		HEX6 <= not hex;
		HEX7 <= not hex;
		
	end process;

end decode;

