-- Import logic primitives
library ieee;
use ieee.std_logic_1164.all;

-- Full Adder Entity
entity full is

	port (A, B, Cin: in std_logic;
			Sum, Cout: out std_logic);
			
end full;

-- Simple Gate Level Description
architecture gates of full is
	signal xorg: std_logic;
begin
	
	xorg <= A xor B;
	Sum <= xorg xor Cin;
	Cout <= (xorg and Cin) or (A and B);

end gates;