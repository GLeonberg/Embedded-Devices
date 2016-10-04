-- Import logic primitives
library ieee;
use ieee.std_logic_1164.all;

-- Half Adder Entity
entity half is

	port(A, B: in std_logic;
		  Sum, Cout: out std_logic);
		  
end half;

-- Simple Gate Level Description
architecture gates of half is
begin

Sum <= A xor B;
Cout <= A and B;

end gates;
