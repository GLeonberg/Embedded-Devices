-- Import logic primitives
library ieee;
use ieee.std_logic_1164.all;

-- Entity for 4 Bit Full Adder
entity fourBitFull is

	port (A, B: in std_logic_vector(3 downto 0);
			Cin: in std_logic;
			Sum: out std_logic_vector(3 downto 0);
			Cout: out std_logic);

end fourBitFull;

-- Structural Architecture
architecture structural of fourBitFull is

	-- Component Declaration to Re-Use Single Bit Full Adder Design
	component full
		port (A, B, Cin: in std_logic;
				Sum, Cout: out std_logic);
	end component;
	
	-- Intermediate Signals for Wiring Components
	signal cins, couts: std_logic_vector(3 downto 0);
	
begin

	-- Generate the 4 Single Bit Full Adders
	makeComponents:
		for i in 0 to 3 generate
			adders: full 
			port map (A => A(i), B => B(i), Cin => cins(i), Sum => Sum(i), Cout => couts(i));
		end generate;

	-- Wire the Carries for the Adders
	cins(0) <= Cin;
	cins(1) <= couts(0);
	cins(2) <= couts(1);
	cins(3) <= couts(2);
	Cout <= couts(3);
	
end structural;