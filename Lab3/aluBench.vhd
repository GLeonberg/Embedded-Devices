----------------------------------------------------------
-- Import Logic Primives
----------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

----------------------------------------------------------
-- Empty Entity for aluBench
----------------------------------------------------------
entity aluBench is
end aluBench;

----------------------------------------------------------
-- Architecture for aluBench
----------------------------------------------------------
architecture bench of aluBench is

	----------------------------------------------------------
	-- Component to Test
	----------------------------------------------------------
	component SN74LS382A is
		port (A, B: in std_logic_vector(3 downto 0); -- Input 4 bit vectors
			Cn: in std_logic; -- Carry In
			S: in std_logic_vector(2 downto 0); -- Opcode
			F: out std_logic_vector(3 downto 0); -- Output
			Cn4, OVR: out std_logic); -- Carry Out and Overflow Indicator
	end component;

	----------------------------------------------------------
	-- Intermediate Signals used for Testing
	----------------------------------------------------------
	signal A, B, F: std_logic_vector(3 downto 0);
	signal Cn, Cn4, OVR: std_logic;
	signal S: std_logic_vector(2 downto 0);
	signal Aint, Bint, Atwos, Btwos, Asig, Bsig, Fsig, Cnint, Sint, Fint, Cn4int, OVRint: integer := 0;

begin

	----------------------------------------------------------
	-- Instantiate ALU to test
	----------------------------------------------------------
	alu: SN74LS382A port map (A => A, B => B, Cn => Cn, S => S, F => F, Cn4 => Cn4, OVR => OVR);

	----------------------------------------------------------
	-- Test against behavioral description
	----------------------------------------------------------

	process 
	begin

		S <= "000";

		----------------------------------------------------------
		-- Loop for S begin
		----------------------------------------------------------
		for h in 0 to 7 loop

			case h is
				when 0 => report "Testing 'CLEAR' Function";
				when 1 => report "Testing 'B MINUS A' Function";
				when 2 => report "Testing 'A MINUS B' Function";
				when 3 => report "Testing 'PLUS' Function";
				when 4 => report "Testing 'XOR' Function";
				when 5 => report "Testing 'OR' Function";
				when 6 => report "Testing 'AND' Function";
				when 7 => report "Testing 'PRESET' Function";
			end case;

			----------------------------------------------------------
			-- Initialize Signals to 0 before testing
			----------------------------------------------------------
			Cn <= '0';
			A <= "0000";
			B <= "0000";

			----------------------------------------------------------
			-- Loop for Cn begin
			----------------------------------------------------------
			for i in 0 to 1 loop
				----------------------------------------------------------
				-- Loop for A begin
				----------------------------------------------------------
				for j in 0 to 15 loop
					----------------------------------------------------------
					-- Loop for B begin
					----------------------------------------------------------
					for k in 0 to 15 loop

						wait for 10 ps;

						Aint <= to_integer(unsigned(A));
						Bint <= to_integer(unsigned(B));
						Fint <= to_integer(unsigned(F));
						Sint <= to_integer(unsigned(S));
						Atwos <= to_integer(unsigned(not A) + 1);
						Btwos <= to_integer(unsigned(not B) + 1);
						Asig <= to_integer(signed(A));
						Bsig <= to_integer(signed(B));
						Fsig <= to_integer(signed(F));
						
						if (Cn = '1') then Cnint <= 1;
						else Cnint <= 0;
						end if; 

						if (Cn4 = '1') then Cn4int <= 1;
						else Cn4int <= 0;
						end if; 

						if (OVR = '1') then OVRint <= 1;
						else OVRint <= 0;
						end if; 

						----------------------------------------------------------
						-- Case with S to determine which function to test
						----------------------------------------------------------
						case S is

							----------------------------------------------------------
							-- Clear
							----------------------------------------------------------
							when "000" =>

								assert Fint = 0 
								report "Error with F in clr when A, B, Cn = " 
								& integer'image(Aint) & ", " & integer'image(Bint) & ", " 
								& integer'image(Cnint)
								severity error;

								assert Cn4int = 0 
								report "Error with Cn4 in clr when A, B, Cn = " 
								& integer'image(Aint) & ", " & integer'image(Bint) & ", " 
								& integer'image(Cnint)
								severity error;

								assert OVRint = 0 
								report "Error with OVR in clr when A, B, Cn = " 
								& integer'image(Aint) & ", " & integer'image(Bint) & ", " 
								& integer'image(Cnint)
								severity error;

							----------------------------------------------------------
							-- B minus A
							----------------------------------------------------------
							when "001" =>

								
								if (Bint >= Aint) then

									-- Check F
									assert Fint = Bint - Aint
									report "Error with F in B minus A when B = "
									& integer'image(Bint) & ", A =  " & integer'image(Aint) 
									& ", F = " & integer'image(Fint)
									severity error;

								else
									-- Check F when B < A
									assert Fint = 16 - (Aint - Bint)
									report "Error with F in B minus A when B = "
									& integer'image(Bint) & ", A =  " & integer'image(Aint) 
									& ", F = " & integer'image(Fint)
									severity error;

								end if;

								if (Atwos + Bint > 15 or Aint = 0) then

									-- Check Cn4
									assert Cn4int /= 0 
									report "Error with Cn4 in B minus A when A = " 
									& integer'image(Aint) & ", B = " & integer'image(Bint) 
									& ", Cn4 = " & integer'image(Cn4int)
									severity error;

								else

									-- Check Cn4
									assert Cn4int = 0 
									report "Error with Cn4 in B minus A when A = " 
									& integer'image(Aint) & ", B = " & integer'image(Bint) 
									& ", Cn4 = " & integer'image(Cn4int)
									severity error;

								end if;

							----------------------------------------------------------
							-- A minus B
							----------------------------------------------------------
							when "010" =>

								if (Aint >= Bint) then

									-- Check F
									assert Fint = Aint - Bint
									report "Error with F in A minus B when B = "
									& integer'image(Bint) & ", A =  " & integer'image(Aint) 
									& ", F = " & integer'image(Fint)
									severity error;

								else
									-- Check F when A < B
									assert Fint = 16 - (Bint - Aint)
									report "Error with F in A minus B when B = "
									& integer'image(Bint) & ", A =  " & integer'image(Aint) 
									& ", F = " & integer'image(Fint)
									severity error;

								end if;

								if (Btwos + Aint > 15 or Bint = 0) then

									-- Check Cn4
									assert Cn4int /= 0 
									report "Error with Cn4 in A minus B when A = " 
									& integer'image(Aint) & ", B = " & integer'image(Bint) 
									& ", Cn4 = " & integer'image(Cn4int)
									severity error;

								else

									-- Check Cn4
									assert Cn4int = 0 
									report "Error with Cn4 in A minus B when A = " 
									& integer'image(Aint) & ", B = " & integer'image(Bint) 
									& ", Cn4 = " & integer'image(Cn4int)
									severity error;

								end if;

							----------------------------------------------------------
							-- A plus B
							----------------------------------------------------------
							when "011" =>

								if ((Aint + Bint + Cnint) < 16) then
									assert Fint = Aint + Bint + Cnint
									report "Error with F in A plus B when A = "
									& integer'image(Aint) & ", B = " & integer'image(Bint) 
									& ", Cn = " & integer'image(Cnint) & 
									", F = " & integer'image(Fint)
									severity error;
								else
									assert Fint = ((Aint + Bint + Cnint) - 16)
									report "Error with F in A plus B when A = "
									& integer'image(Aint) & ", B = " & integer'image(Bint) 
									& ", Cn = " & integer'image(Cnint) & 
									", F = " & integer'image(Fint)
									severity error;
								end if;

								if Aint + Bint + Cnint > 15 then
									assert Cn4int /= 0
									report "Error with Cn4 in A plus B when A = "
									& integer'image(Aint) & ", B = " & integer'image(Bint) 
									& ", Cn = " & integer'image(Cnint) & 
									", Cn4 = " & integer'image(Cn4int)
									severity error;
								else
									assert Cn4int = 0
									report "Error with Cn4 in A plus B when A = "
									& integer'image(Aint) & ", B = " & integer'image(Bint) 
									& ", Cn = " & integer'image(Cnint) & 
									", Cn4 = " & integer'image(Cn4int)
									severity error;
								end if;

							----------------------------------------------------------
							-- A xor B
							----------------------------------------------------------
							when "100" =>
								assert F = (A xor B)
								report "Error with F in A xor B when A = "
								& integer'image(Aint) & ", B = " & integer'image(Bint) & ", Cn = " 
								& integer'image(Cnint) & ", F = " & integer'image(Fint)
								severity error;

							----------------------------------------------------------
							-- A or B
							----------------------------------------------------------
							when "101" =>
								assert F = (A or B)
								report "Error with F in A or B when A = "
								& integer'image(Aint) & ", B = " & integer'image(Bint) & ", Cn = " 
								& integer'image(Cnint) & ", F = " & integer'image(Fint)
								severity error;
		
							----------------------------------------------------------
							-- A and B
							----------------------------------------------------------
							when "110" =>
								assert F = (A and B)
								report "Error with F in A and B when A = "
								& integer'image(Aint) & ", B = " & integer'image(Bint) & ", Cn = "
								& integer'image(Cnint) & ", F = " & integer'image(Fint)
								severity error;

							----------------------------------------------------------
							-- Preset High
							----------------------------------------------------------
							when "111" =>
								assert F = "1111"
								report "Error with F in Preset High when A = "
								& integer'image(Aint) & ", B = " & integer'image(Bint) & ", Cn = " 
								& integer'image(Cnint) & ", F = " & integer'image(Fint)
								severity error;

								assert Cn4 = '1'
								report "Error with Cn4 in Preset High when A = "
								& integer'image(Aint) & ", B = " & integer'image(Bint) & ", Cn = " 
								& integer'image(Cnint) & ", Cn4 = " & integer'image(Cn4int)
								severity error;

							----------------------------------------------------------
							-- Null State
							----------------------------------------------------------
							when others => null;

						----------------------------------------------------------
 						end case;
						----------------------------------------------------------

						-- Increment B
						if (B = "1111") then B <= "0000";
						else B <= std_logic_vector(to_unsigned(to_integer(unsigned(B)) + 1, 4));
						end if;

						wait for 90 ps; -- Wait for next 100ps clock cycle

					----------------------------------------------------------
					-- Loop for B end
					----------------------------------------------------------
					end loop;

				-- Increment A
				if (A = "1111") then A <= "0000";
				else A <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) + 1, 4));
				end if;
				
				----------------------------------------------------------
				-- Loop for A end
				----------------------------------------------------------
				end loop;

			-- Increment Cn
			Cn <= not Cn;

			----------------------------------------------------------
			-- Loop for Cn end
			----------------------------------------------------------
			end loop;

			-- Increment S
			if (S = "111") then S <= "000";
			else S <= std_logic_vector(to_unsigned(to_integer(unsigned(S)) + 1, 3));
			end if;

		----------------------------------------------------------
		-- Loop for S end	
		----------------------------------------------------------
		end loop;	
		 
		----------------------------------------------------------
		-- Signify Completion of Testing
		----------------------------------------------------------
		report "Test Completed";
		wait;
		
	end process;
	
end bench;
