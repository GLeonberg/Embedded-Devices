-- Import Logic Primitives
library ieee;
use ieee.std_logic_1164.all;

-- Entity for Testing simpleALU on DE2-115 Board
entity aluTester is
port (SW: in std_logic_vector (12 downto 0);
		hex3, hex5, hex7: out std_logic_vector(6 downto 0);
		ledg: out std_logic_vector(0 downto 0);
		ledr: out std_logic_vector(1 downto 1) );
end aluTester;

-- Architecture for aluTester on DE2-115
architecture structural of aluTester is

	-- simpleALU component to test on board
	component simpleALU
		port(in1, in2: in std_logic_vector(3 downto 0);
			  Amux, Bmux: in std_logic_vector(1 downto 0);
			  Cin: in std_logic;
			  Sum: out std_logic_vector(3 downto 0);
			  Cout: out std_logic);
	end component;
	
	-- Seven Segment Decoder
	component fourBinToSevenSeg
		port (bin: in std_logic_vector(3 downto 0);
				hex: out std_logic_vector(6 downto 0) );	
	end component;
	
	-- Intermediate Signals for Output LEDs
	signal overflow: std_logic;
	signal A, B, S: std_logic_vector(3 downto 0);
	
begin

	-- generate simpleALU component and do inital wiring
	alu: simpleALU port map 
		(in1 => SW(3 downto 0), in2 => SW(7 downto 4), Amux => SW(9 downto 8),
	  	 Bmux => SW(11 downto 10), Cin => SW(12), Sum => S, Cout => overflow);
		 
	-- generate Hex display for A input 
	AHex: fourBinToSevenSeg port map 
		(bin => SW(3 downto 0), hex => HEX7);
		 
	-- generate Hex display for B input 
	BHex: fourBinToSevenSeg port map 
		(bin => SW(7 downto 4), hex => HEX5);
		
	-- generate Hex display for B input 
	SHex: fourBinToSevenSeg port map 
		(bin => S, hex => HEX3);
	
	-- Single LED for Overflow Indicator
	ledg(0) <= overflow;
	
	-- Single LED for Zero Indicator
	ledr(1) <= (not S(0)) and (not S(1)) and (not S(2)) and (not S(3));

end structural;