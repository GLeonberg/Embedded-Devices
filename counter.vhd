-- Import Logic Primitives
library ieee;
use ieee.std_logic_1164.all;

Entity counter is
	port (key : in std_logic_vector(3 downto 3); -- push button 4 on fpga board
			hex0: out std_logic_vector(6 downto 0);
			hex1: out std_logic_vector(6 downto 0);
			ledr: out std_logic_vector(7 downto 0) );
end counter;

architecture logic of counter is

	signal timer, j, k, q: std_logic_vector(7 downto 0);
	
	-- component declaration for jkflip in file jkflip.vhd
	component jkflip is
	port(clk, j, k: in std_logic;
	     q, qbar: out std_logic);
	end component;
	
	-- Re-use Seven Segment Decoder
	component fourBinToSevenSeg
	port (bin: in std_logic_vector(3 downto 0);
			hex: out std_logic_vector(6 downto 0) );
	end component;

begin

	-- Generate 8 jkflips, map j, k, q pins to bit vectors for later use
	genLoop:
	for i in 0 to 7 generate
		count: jkflip port map(clk => key(3), j => j(i), k => k(i), q => q(i), qbar => open);
	end generate genLoop;

	-- Assign j and k wiring for jkflips
	j(0) <= '1';
	k(0) <= '1';
	
	j(1) <= q(0);
	k(1) <= j(1);
	
	j(2) <= q(1) and q(0);
	k(2) <= j(2);
	
	j(3) <= q(2) and j(2);
	k(3) <= j(3);
	
	j(4) <= q(3) and j(3);
	k(4) <= j(4);
	
	j(5) <= q(4) and j(4);
	k(5) <= j(5);
	
	j(6) <= q(5) and j(5);
	k(6) <= j(6);
	
	j(7) <= q(6) and j(6);
	k(7) <= j(7);
	
	-- Assign time as output of flip-flops
	timer <= q;
	ledr <= timer;
	
	hexDisp1: fourBinToSevenSeg
	port map(bin => timer(7 downto 4), hex => hex0);
	
	hexDisp2: fourBinToSevenSeg
	port map(bin => timer(3 downto 0), hex => hex1);

end logic;