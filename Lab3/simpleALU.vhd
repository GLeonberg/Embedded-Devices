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

	-- Generate the 4 Bit Adder Which Serves as the Base
	fourBits:
		for i in 0 to 0 generate 
			adder: fourBitFull 
			port map (A => As, B => Bs, Cin => Cin, Sum => Sum, Cout => Cout);
		end generate;
		
	-- Process and Case to use Mux-like Behavior
	process(in1, in2, Cin, Amux, Bmux) is begin
	
			-- Selecting Value for A Bits
			case Amux is
			
				-- Normal
				when "00" =>
						As(0) <= in1(0);
						As(1) <= in1(1);
						As(2) <= in1(2);
						As(3) <= in1(3);
				
				-- Negate
				when "01" => 
						As(0) <= not in1(0);
						As(1) <= not in1(1);
						As(2) <= not in1(2);
						As(3) <= not in1(3);
				
				-- Zero		
				when "10" => 
						As(0) <= '0';
						As(1) <= '0';
						As(2) <= '0';
						As(3) <= '0';
				
				-- Null (unused state)	
				when others =>
						As(0) <= 'X';
						As(1) <= 'X';
						As(2) <= 'X';
						As(3) <= 'X';
						
			end case;
			
			-- Selecting Value for B Bits
			case Bmux is
			
				-- Normal
				when "00" =>
						Bs(0) <= in2(0);
						Bs(1) <= in2(1);
						Bs(2) <= in2(2);
						Bs(3) <= in2(3);
				
				-- Negate
				when "01" => 
						Bs(0) <= not in2(0);
						Bs(1) <= not in2(1);
						Bs(2) <= not in2(2);
						Bs(3) <= not in2(3);
				
			   -- Zero	
				when "10" => 
						Bs(0) <= '0';
						Bs(1) <= '0';
						Bs(2) <= '0';
						Bs(3) <= '0';
						
				-- Null (unused state)
				when others =>
						Bs(0) <= 'X';
						Bs(1) <= 'X';
						Bs(2) <= 'X';
						Bs(3) <= 'X';
						
			end case;
	
	end process;

end structural;