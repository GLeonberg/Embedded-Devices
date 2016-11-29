library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ALU is
	port (A, B: in std_logic_vector(7 downto 0);
			opcode: in std_logic_vector(2 downto 0);
			output: out std_logic_vector(7 downto 0) );
end ALU;

architecture behavioral of ALU is
begin

	process(A, B, opcode) begin
	
		case opcode is
		
			when "000" => -- AND
				output <= A and B;
			
			when "001" => -- OR
				output <= A or B;
			
			when "010" => -- NAND
				output <= A nand B;
			
			when "011" => -- NOR
				output <= A nor B;
			
			when "100" => -- XOR
				output <= A xor B;
			
			when "101" => -- ADD
				output <= A + B;
			
			when "110" => -- SUB
				output <= A - B;
			
			when "111" => -- SRL
			
				-- Switch Based on SHAMT
				case B is
					when "00000001" => output <= "0" & A(7 downto 1);
					when "00000010" => output <= "00" & A(7 downto 2);
					when "00000011" => output <= "000" & A(7 downto 3);
					when "00000100" => output <= "0000" & A(7 downto 4);
					when "00000101" => output <= "00000" & A(7 downto 5);
					when "00000110" => output <= "000000" & A(7 downto 6);
					when "00000111" => output <= "0000000" & A(7);
					when "00001000" => output <= "00000000";
					when others =>  output <= A;
				end case;
			
			when others =>
				output <= (others => '0');
			
		end case;
	
	end process;

end behavioral;