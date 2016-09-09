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

		if (SW = "0000") then
			HEX0 <= "0111111"; -- 0
		end if;
		
		if (SW = "0001") then
			HEX0 <= "0000110"; -- 1
		end if;
		
		if (SW = "0010") then
			HEX0 <= "1011011"; -- 2
		end if;
		
		if (SW = "0011") then
			HEX0 <= "1001111"; -- 3
		end if;
		
		if (SW = "0100") then
			HEX0 <= "1100110"; -- 4
		end if;
		
		if (SW = "0101") then
			HEX0 <= "1101101"; -- 5
		end if;
		
		if (SW = "0110") then
			HEX0 <= "1111101"; -- 6
		end if;
		
		if (SW = "0111") then
			HEX0 <= "0000111"; -- 7
		end if;
		
		if (SW = "1000") then
			HEX0 <= "1111111"; -- 8
		end if;
		
		if (SW = "1001") then
			HEX0 <= "1100111"; -- 9
		end if;
		
		if (SW = "1010") then
			HEX0 <= "1110111"; -- A
		end if;
		
		if (SW = "1011") then
			HEX0 <= "1111100"; -- b
		end if;
		
		if (SW = "1100") then
			HEX0 <= "0111001"; -- c
		end if;
		
		if (SW = "1101") then 
			HEX0 <= "1011110"; -- d
		end if;
		
		if (SW = "1110") then
			HEX0 <= "1111001"; -- E
		end if;
		
		if (SW = "1111") then
			HEX0 <= "1110001"; -- F
		end if;

	end process;

end decode;

