-- import logic primitives
library ieee;
use ieee.std_logic_1164.all;

entity jkflip is

port (j, k, clk : in std_logic;
	q, qbar : out std_logic);

end jkflip;

architecture behavioral of jkflip is
signal qout, qbarout : std_logic := '0';
begin

qout <=	'1' when j = '1' and k = '0' and clk = '1'else
	'0' when j = '0' and k = '1' and clk = '1' else
	not qout when j = '1' and k = '1' and clk = '1'
	else '0';

qbarout <=      '0' when j = '1' and k = '0' and clk = '1'else
		'1' when j = '0' and k = '1' and clk = '1'else
		not qbarout when j = '1' and k = '1' and clk = '1'
		else '0';

q <= qout;
qbar <= qbarout;
	

end behavioral;