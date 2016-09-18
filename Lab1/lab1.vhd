-- Import logic primitives
library ieee;
use ieee.std_logic_1164.all;

-- Simple module that connects the SW switches to the LEDR lights
entity lab1 is

port ( SW: in STD_LOGIC_VECTOR(17 downto 0); -- Initialize switches as an input
	    LEDR: out STD_LOGIC_VECTOR(17 downto 0) ); -- Initialize red LEDs as an output

end lab1;


-- Define characteristics of the entity lab1
architecture Behavior of lab1 is
begin

	LEDR <= SW; -- Assign each switch to one red LED
	
end Behavior;
