
-- Import logic primitives
library ieee;
use ieee.std_logic_1164.all;

-- Clocked SR Flip-Flop
entity setreset is

	port ( s, r, clk : in std_logic;
		q, qbar : out std_logic );

end setreset;



architecture logic of setreset is

	-- Intermediate Signals
	signal randg, sandg, rorg, sorg  : std_logic;
	
begin
	
	-- nand gates to tie to clock
	sandg <= not(r and clk);
	randg <= not(s and clk);

	-- criss-cross to get latch effect
	rorg <= not (randg and sorg);
	sorg <= not (sandg and rorg);
	
	-- assign output
	q <= rorg;
	qbar <= sorg;

end logic;