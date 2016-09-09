-- Import logic primitives
library ieee;
use ieee.std_logic_1164.all;

-- Combine 7seg and decoder into 1 entity
entity lab1activity2 is

port (SW: in std_logic_vector(3 downto 0);
      HEX0: out std_logic_vector(6 downto 0) );

end lab1activity2;

-- Basically a big switch statement
-- for the architecture
architecture decode of lab1activity2 is
begin

	process (SW) is begin
	
		case SW is 

			when "0000" => HEX0 <= "0111111"; -- 0
			when "0001" => HEX0 <= "0000110"; -- 1
			when "0010" => HEX0 <= "1011011"; -- 2
			when "0011" => HEX0 <= "1001111"; -- 3
			when "0100" => HEX0 <= "1100110"; -- 4
			when "0101" => HEX0 <= "1101101"; -- 5
			when "0110" => HEX0 <= "1111101"; -- 6
			when "0111" => HEX0 <= "0000111"; -- 7
			when "1000" => HEX0 <= "1111111"; -- 8
			when "1001" => HEX0 <= "1100111"; -- 9
			when "1010" => HEX0 <= "1110111"; -- A
			when "1011" => HEX0 <= "1111100"; -- b
			when "1100" => HEX0 <= "0111001"; -- c
			when "1101" => HEX0 <= "1011110"; -- d
			when "1110" => HEX0 <= "1111001"; -- E
			when "1111" => HEX0 <= "1110001"; -- F

		end case;
		
	end process;

end decode;

