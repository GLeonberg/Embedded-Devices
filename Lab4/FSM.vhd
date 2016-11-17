library ieee;
use ieee.std_logic_1164.all;

entity prelab is
port (input: in std_logic_vector(1 downto 0);
		clk, reset: in std_logic;
		output: out std_logic_vector(1 downto 0));
end prelab;

architecture fsm of prelab is

	TYPE STATE_TYPE IS (A, B, C, D, E);
	signal state, nex : STATE_TYPE := A;
	
begin


		-- Apply next state or reset on clock
		process(reset, clk) begin
			if reset = '1' then
				state <= A;
			elsif rising_edge(clk) then
				state <= nex;
			else
				state <= state;
			end if;
		end process;

		-- Apply actions for specific state and calculate next state
		process(state, input) begin
		
				case state is
				
					when A =>
						if input(0) = '1' then
							nex <= D;
							output <= "01";
						else
							nex <= A;
							output <= "00";
						end if;
						
					when B =>
						if input = "11" then
							nex <= A;
							output <= "01";
						elsif input = "01" then
							nex <= E;
							output <= "00";
						elsif input = "00" then
							nex <= C;
							output <= "10";
						else
							nex <= D;
							output <= "11";
						end if;
					
					when C =>
						if input(1) = '1' then
							nex <= B;
							output <= "10";
						else
							nex <= E;
							output <= "01";
						end if;
					
					when D =>
						if input = "00" then
							nex <= A;
							output <= "01";
						elsif input = "01" then
							nex <= E;
							output <= "10";
						else
							nex <= D;
							output <= "XX";
						end if;
					
					when E =>
						if input = "00" then
							nex <= E;
							output <= "01";
						elsif input = "10" then
							nex <= B;
							output <= "11";
						elsif input = "11" then
							nex <= D;
							output <= "00";
						else
							nex <= E;
							output <= "XX";
						end if;
					
				end case;
				
		end process;

end fsm;
