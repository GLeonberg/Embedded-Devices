-- Import logic primitives
library ieee;
use ieee.std_logic_1164.all;

-- Simple boolean logic ckt

-- Z = !( !(X or !Y) and (!x and y) )
-- where X and Y are inputs from SW(1) and SW(2)
-- and Z is an LEDR output light

entity lab1activity1 is

	port (SW: in std_logic_vector(17 downto 0); -- Switches as input
			LEDR: out std_logic_vector(17 downto 0) ); -- red LEDs as output
			
end lab1activity1;


-- Implementation of boolean logic
architecture logic of lab1activity1 is
begin

	process (SW) is begin
	
		LEDR(0) <= not( (SW(2) and not SW(1)) and not(not SW(2) or SW(1) ) ); -- Logic as shown in figure 20
		
	end process;

end logic;