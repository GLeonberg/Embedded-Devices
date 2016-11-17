library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY Machine IS
   port ( SW : in std_logic_vector(15 downto 0);
			 KEY : in std_logic_vector(3 downto 0);
			 LEDR : out std_logic_vector(17 downto 0);
			 LEDG : out std_logic_vector(2 downto 0);
			 HEX0 : out std_logic_vector(6 downto 0);
			 HEX1 : out std_logic_vector(6 downto 0);
			 HEX2 : out std_logic_vector(6 downto 0);
			 HEX3 : out std_logic_vector(6 downto 0);
			 HEX4 : out std_logic_vector(6 downto 0);
			 HEX5 : out std_logic_vector(6 downto 0);
			 HEX6 : out std_logic_vector(6 downto 0);
			 HEX7 : out std_logic_vector(6 downto 0) );
			 
END Machine;

architecture arch of Machine is
   TYPE STATE_TYPE IS (IDLE, SEL, VND);
	signal quarters, dollars : std_logic_vector(5 downto 0) := "000000";
   SIGNAL state   : STATE_TYPE := IDLE;
	signal reset : std_logic := '0';
	
BEGIN

	-- Asynchronous quarters counting
	process (KEY(2), reset)
	begin
	
		if reset = '1' then
			quarters <= "000000";
		elsif(rising_edge(KEY(2))) then
			QUARTERS <= QUARTERS + 1;
		end if;
	
	end process;
	
	-- Asynchronous dollars counting
	process (KEY(3), reset)
	begin
	
		if reset = '1' then
			dollars <= "000000";
		elsif(rising_edge(KEY(3))) then
			dollars <= dollars + 1;
		end if;
	
	end process;
	
	-- Transition to next state synchronously
   PROCESS (KEY(0), KEY(1))
   BEGIN
	
	
      IF KEY(1) = '0' THEN
			reset <= '1';
         state <= IDLE;
			
      ELSIF (rising_edge(KEY(0))) THEN
		reset <= '0';
         CASE state IS
			
            WHEN IDLE =>
					reset <= '1';
               IF SW = "1111000000000000" or SW = "0000111100000000" or
						SW = "0000000011110000" or SW = "0000000000001111" THEN
                  state <= SEL;
               ELSE
                  state <= IDLE;
               END IF;
					
            WHEN SEL =>
				
					-- invalid product, go back to idle
					if not(SW = "1111000000000000" or
							 SW = "0000111100000000" or
							 SW = "0000000011110000" or
							 SW = "0000000000001111") then
							 state <= IDLE;
							
					-- valid product, check if enough money has been input
               elsif (("0100"*dollars+quarters) > 3 and SW = "1111000000000000") or
						(("0100"*dollars+quarters) > 2 and SW = "0000111100000000") or
						(("0100"*dollars+quarters) > 1 and SW = "0000000011110000") or
						(("0100"*dollars+quarters) > 0 and SW = "0000000000001111") THEN
						
                  state <= VND;
					else
						state <= SEL;
               end if;
					
            WHEN VND =>
                  state <= IDLE;
					
         END CASE;
			
      END IF;
		
   END PROCESS;
   
	-- Perform actions for state asynchronously
   PROCESS (state, quarters, dollars)
   BEGIN
      CASE state IS
		
         WHEN IDLE =>
				HEX0 <= "0111111";
				HEX1 <= "0111111";
				HEX2 <= "0111111";
				HEX3 <= "0111111";
				HEX4 <= "0111111";
				HEX5 <= "0111111";
				HEX6 <= "0111111";
				HEX7 <= "0111111";
				LEDG <= "001";
				LEDR <= "000000000000000000";
 
         WHEN SEL =>
            LEDR <= "000000000000000000";
				HEX2 <= "1111111";
				HEX3 <= "1111111";
				HEX6 <= "1111111";
				HEX7 <= "1111111";
				LEDG <= "010";
				
				-- Display current number of dollars entered on HEX1
				if(dollars = 0) then HEX1 <= "1000000";
				elsif(dollars = 1) then HEX1 <= "1111001";
				elsif(dollars = 2) then HEX1 <= "0100100";
				elsif(dollars = 3) then HEX1 <= "0110000";
				elsif(dollars = 4) then HEX1 <= "0011001";
				elsif(dollars = 5) then HEX1 <= "0010010";
				elsif(dollars = 6) then HEX1 <= "0000010";
				elsif(dollars = 7) then HEX1 <= "1111000";
				elsif(dollars = 8) then HEX1 <= "0000000";
				elsif(dollars = 9) then HEX1 <= "0011000";
				else HEX1 <= "1111111";
				end if;
				
				-- Display current number of quarters entered on HEX0
				if(quarters = 0) then HEX0 <= "1000000";
				elsif(quarters = 1) then HEX0 <= "1111001";
				elsif(quarters = 2) then HEX0 <= "0100100";
				elsif(quarters = 3) then HEX0 <= "0110000";
				elsif(quarters = 4) then HEX0 <= "0011001";
				elsif(quarters = 5) then HEX0 <= "0010010";
				elsif(quarters = 6) then HEX0 <= "0000010";
				elsif(quarters = 7) then HEX0 <= "1111000";
				elsif(quarters = 8) then HEX0 <= "0000000";
				elsif(quarters = 9) then HEX0 <= "0011000";
				else HEX0 <= "1111111";
				end if;
				
				-- SODA price display
				if(SW = "1111000000000000") then
					HEX5 <= "1000000";
					HEX4 <= "0011001";
				
				-- CHIPS price display
				elsif(SW = "0000111100000000") then
					HEX5 <= "1000000";
					HEX4 <= "0110000";
					
				-- CHOCOLATE price display
				elsif(SW = "0000000011110000") then
					HEX5 <= "1000000";
					HEX4 <= "0100100";
					
				-- GUM price display
				else
					HEX5 <= "1000000";
					HEX4 <= "1111001";
				end if;
				
				
				
				
         WHEN others =>
            HEX0 <= "1111111";
				HEX1 <= "1111111";
				HEX2 <= "1111111";
				HEX3 <= "1111111";
				HEX4 <= "1111111";
				HEX5 <= "1111111";
				HEX6 <= "1111111";
				HEX7 <= "1111111";
				LEDG <= "100";
				LEDR <= "111111111111111111";
				
      END CASE;
   END PROCESS;
   
END arch;
