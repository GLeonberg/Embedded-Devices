-- Import logic primitives
library ieee;
use ieee.std_logic_1164.all;

-- SR Flip-Flop is almost same as Dff
entity srff is

port ( s, r, clk : in std_logic;
		q, qbar : out std_logic );

end srff;


architecture logic of srff is

	-- Intermediate Signals
	signal d, d1, d2, qa, qb : std_logic;
	
begin

	d <= s and not r; -- When S = 1 and R = 0, D = 1
	d1 <= not(d and clk);
	d2 <= not(d1 and clk);
	qa <= not(d1 and qb);
	qb <= not(d2 and qa);
	
	q <= qa;
	qbar <= qb;

end logic;
