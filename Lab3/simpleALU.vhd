-- Import Logic Primitives
library ieee;
use ieee.std_logic_1164.all;

-- Entity for ALU
entity simpleALU is

	port(in1, in2: in std_logic_vector(3 downto 0);
		  Amux, Bmux: in std_logic_vector(1 downto 0);
		  Cin: in std_logic;
		  Sum: out std_logic_vector(3 downto 0);
		  Cout: out std_logic);
		  
end simpleALU;

-- Structural Architecture for ALU, Re-use 4 Bit Adder Code
architecture structural of simpleALU is

	-- Component Declaration to Re-Use Entity
	component fourBitFull 
		port (A, B: in std_logic_vector(3 downto 0);
				Cin: in std_logic;
				Sum: out std_logic_vector(3 downto 0);
				Cout: out std_logic);
	end component;
	
	-- Intermediate Signals for Mux Wiring
	signal As, Bs: std_logic_vector(3 downto 0);
	
begin

	-- 4 Bit Adder Which Serves as the Base
		adder: fourBitFull 
		port map (A => As, B => Bs, Cin => Cin, Sum => Sum, Cout => Cout);
		
	-- Process and Case to use Mux-like Behavior
	process(in1, in2, Cin, Amux, Bmux) is begin
	
			-- Selecting Value for A Bits
			case Amux is
			
				when "00" => As <= in1; -- Normal
				when "01" => As <= not in1; -- Negate	
				when "10" => As <= "0000"; -- Zero		
				when others => As <= "XXXX"; -- Null (unused state)	
						
			end case;
			
			-- Selecting Value for B Bits
			case Bmux is
			
				when "00" => Bs <= in2; -- Normal
				when "01" => Bs <= not in2; -- Negate	
				when "10" => Bs <= "0000"; -- Zero		
				when others => Bs <= "XXXX"; -- Null (unused state)	
						
			end case;
	
	end process;

end structural;