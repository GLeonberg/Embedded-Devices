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
	end component jkflip;

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
	-- Display time in hex to two displays
	process (timer) is begin
	
		case timer(7 downto 4) is
			when "0000" => hex0 <= "1000000"; -- 0
			when "0001" => hex0 <= "1111001"; -- 1
			when "0010" => hex0 <= "0100100"; -- 2
			when "0011" => hex0 <= "0110000"; -- 3
			when "0100" => hex0 <= "0011001"; -- 4
			when "0101" => hex0 <= "0010010"; -- 5
			when "0110" => hex0 <= "0000010"; -- 6
			when "0111" => hex0 <= "1111000"; -- 7
			when "1000" => hex0 <= "0000000"; -- 8
			when "1001" => hex0 <= "0011000"; -- 9
			when "1010" => hex0 <= "0001000"; -- A
			when "1011" => hex0 <= "0000011"; -- b
			when "1100" => hex0 <= "0100111"; -- c
			when "1101" => hex0 <= "0100001"; -- d
			when "1110" => hex0 <= "0000110"; -- E
			when "1111" => hex0 <= "0001110"; -- F
			when others => hex0 <= "1111111"; -- null
		end case;
		
		case timer(3 downto 0) is
			when "0000" => hex1 <= "1000000"; -- 0
			when "0001" => hex1 <= "1111001"; -- 1
			when "0010" => hex1 <= "0100100"; -- 2
			when "0011" => hex1 <= "0110000"; -- 3
			when "0100" => hex1 <= "0011001"; -- 4
			when "0101" => hex1 <= "0010010"; -- 5
			when "0110" => hex1 <= "0000010"; -- 6
			when "0111" => hex1 <= "1111000"; -- 7
			when "1000" => hex1 <= "0000000"; -- 8
			when "1001" => hex1 <= "0011000"; -- 9
			when "1010" => hex1 <= "0001000"; -- A
			when "1011" => hex1 <= "0000011"; -- b
			when "1100" => hex1 <= "0100111"; -- c
			when "1101" => hex1 <= "0100001"; -- d
			when "1110" => hex1 <= "0000110"; -- E
			when "1111" => hex1 <= "0001110"; -- F
			when others => hex1 <= "1111111"; -- null
		end case;
		
	end process;

end logic;