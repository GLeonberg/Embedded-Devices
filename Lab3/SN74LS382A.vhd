-- Import Logic Primitives
library ieee;
use ieee.std_logic_1164.all;

-- Entity for SN74LS382A Chip
entity SN74LS382A is
	port (A, B: in std_logic_vector(3 downto 0); -- Input 4 bit vectors
			Cn: in std_logic; -- Carry In
			S: in std_logic_vector(2 downto 0); -- Opcode
			F: out std_logic_vector(3 downto 0); -- Output
			Cn4, OVR: out std_logic); -- Carry Out and Overflow Indicator
end SN74LS382A;

-- Structural Architecture for SN74LS382A, Re-use 4 Bit Adder Code
architecture structural of SN74LS382A is

	-- Reuse Four Bit Ripple Carry Adder to make SN74LS382A
	component fourBitFullMod
			port (inA, inB: in std_logic_vector(3 downto 0);
					Cin: in std_logic;
					Sum: out std_logic_vector(3 downto 0);
					Cout, Cn3: out std_logic);
	end component;

	-- Intermediate Signals for Wiring
	signal inA, inB: std_logic_vector(3 downto 0);
	signal Cin, Cn3, Cout, Cn4temp: std_logic;
	
begin

	-- Instantiate fourBitFull and Wire to Intermediate Signals
	fourBit: fourBitFullMod
		port map(inA => inA, inB => inB, Cin => Cin, Sum => F, Cout => Cout, Cn3 => Cn3);
	
	OVR <= Cout xor Cn3;
	Cn4 <= Cout;
	
	-- Process for ALU Functions
	process (S, A, B, Cn) is begin
	
		case S is
		
			-- Clear
			when "000" =>
				 inA <= "0000";
				 inB <= "0000";
				 Cin <= '0';
				 
			-- B minus A
			when "001" =>
				inA <= not A;
				inB <= B;
				Cin <= '1';
	
			-- A minus B
			when "010" =>
				inA <= A;
				inB <= not B;
				Cin <= '1';
			
			-- A plus B
			when "011" =>
				inA <= A;
				inB <= B;
				Cin <= Cn;
			
			-- A xor B
			when "100" =>
				inA <= A xor B;
				inB <= "0000";
				Cin <= '0';
			
			-- A or B
			when "101" =>
				inA <= A or B;
				inB <= "0000";
				Cin <= '0';
			
			-- A and B
			when "110" =>
				inA <= A and B;
				inB <= "0000";
				Cin <= '0';
			
			-- Preset
			when "111" =>
				inA <= "1111";
				inB <= "1111";
				Cin <= '1';
			
			-- Null State
			when others =>
				inA <= "0000";
				inB <= "0000";
	
		end case;
	
	end process;

end structural;