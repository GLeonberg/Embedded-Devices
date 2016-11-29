-- Import basic libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- simpleCPU: 	A Von-Neumann architecture single cycle processor
--					Has no general purpose registers
--					All data held in memory
--					Instructions come from user input switches

--					Interfaces with 2MB SRAM chip on DE2-115 Board
--					Features a Load-Immediate Instruction

-- CLOCK_50 is SRAM clock
-- KEY1 is reset, KEY0 is CPU clock
-- LEDG is current state of Control FSM (one hot)

entity simpleCPU is
	port (CLOCK_50: in std_logic;
			SRAM_ADDR: out std_logic_vector(4 downto 0);
			SRAM_DQ: inout std_logic_vector(7 downto 0);
			SRAM_CE_N: buffer std_logic;
			SRAM_OE_N: buffer std_logic;
			SRAM_WE_N: buffer std_logic;
			SRAM_LB_N, SRAM_UB_N: buffer std_logic;
			SW: in std_logic_vector (17 downto 0);
			KEY: in std_logic_vector(3 downto 0);
			HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7: out std_logic_vector (6 downto 0);
			LEDG: out std_logic_vector(3 downto 0) );
end simpleCPU;

architecture fsm of simpleCPU is

	-- Define States for CPU 
	-- (Due to SRAM only being single port, need seperate states to read A and B operands from memory)
	type state is (FETCH, DECODE, READB, EXECUTE, MEMORY, IMMEDIATE);
	attribute syn_encoding: string;
	
	-- State signals for FSM
	signal curr, nex: state := FETCH;
	
	-- Program Counter
	signal PC: std_logic_vector(4 downto 0) := (others => '0');
	
	-- Instruction Word
	signal IR: std_logic_vector(17 downto 0) := (others => '0');
	
	-- Opcode
	signal OP: std_logic_vector(2 downto 0) := (others => '0');
	
	-- Operand and Product Registers
	signal A, B, C: std_logic_vector(7 downto 0) := (others => '0');
	
	-- Operand and Product Memory Addresses
	signal Aloc, Bloc, Cloc: std_logic_vector(4 downto 0) := (others => '0');
	
	-- Memory Control Signals
	signal memWrite, memReadA, memReadB: std_logic := '0';
	
	-- ALU inputs and output
	signal ALUA, ALUB, ALUC : std_logic_vector(7 downto 0) := (others => '0');

	-- Declare Arrays for Hex Decoder Use
	type hexI is array (0 to 7) of std_logic_vector(3 downto 0);
	type hexO is array (0 to 7) of std_logic_vector(6 downto 0);
	
	-- Hex Decoder Signals
	signal hexIn: hexI;
	signal hexOut: hexO;
	
	-- ALU
	component ALU
	port (A, B: in std_logic_vector(7 downto 0);
			opcode: in std_logic_vector(2 downto 0);
			output: out std_logic_vector(7 downto 0) );
	end component;
	
	-- HEX Display
	component fourBinToSevenSeg
	port (bin: in std_logic_vector(3 downto 0);
			hex: out std_logic_vector(6 downto 0) );
	end component;

begin

	-- Set SRAM Signals
	SRAM_UB_N <= '1';
	SRAM_LB_N <= '1';
	SRAM_CE_N <= '0';
	SRAM_WE_N <= not memWrite;
	SRAM_OE_N <= not (memReadA or memReadB);

	-- Instantiate ALU
	aluinst: ALU port map (ALUA, ALUB, OP, ALUC);
	
	-- Generate 8 seven segment decoders
	genloop:
		for i in 0 to 7 generate
			hex: fourBinToSevenSeg port map (hexIn(i), hexOut(i));
		end generate;
		
	-- Synchronously to 50 MHz clock, manage memory
	process(CLOCK_50) begin
		
		if rising_edge(CLOCK_50) then
		
			if memReadA = '1' then
				SRAM_ADDR <= Aloc;
				A <= SRAM_DQ;
				
			elsif memReadB = '1' then
				SRAM_ADDR <= Bloc;
				B <= SRAM_DQ;
				
			elsif memWrite = '1' then
				SRAM_DQ <= C;
				SRAM_ADDR <= Cloc;
			
			end if;
			
		end if;
		
	end process;

	-- Synchronously control state register
	process(KEY) begin
		if KEY(1) = '0' then
			curr <= FETCH;
		elsif rising_edge(KEY(0)) then
			curr <= nex;
		else
			curr <= curr;
		end if;
	end process;
	
	-- Next State Determination
	process(curr) begin
		case curr is
			when FETCH => 
			
				
				if KEY(3) = '1' then
					nex <= DECODE;
				else
					nex <= IMMEDIATE; -- holding down KEY3 triggers Load Immediate
				end if;
			
			when DECODE => nex <= READB;
			when READB => nex <= EXECUTE;
			when EXECUTE => nex <= MEMORY;
			when others => nex <= FETCH;
		end case;
	end process;
	
	-- Program Counter Register
	process(curr, KEY) begin
	
		if KEY(2) = '0' then
			PC <= (others => '0');
			
		elsif (curr = EXECUTE) and rising_edge(KEY(0)) then
				PC <= PC + 1;
		end if;
		
	end process;
	
	-- Current State Execution
	process(curr) begin
		case curr is
		
			when FETCH =>
			
				-- Set Control Signals
				memReadA <= '0';
				memReadB <= '0';
				memWrite <= '0';
				
				-- Set Status Lights
				LEDG <= "1000";
				HEX0 <= "0111111";
				HEX1 <= "0111111";
				HEX2 <= "0111111";
				HEX3 <= "0111111";
				HEX4 <= "0111111";
				HEX5 <= "0111111";
				HEX6 <= "0111111";
				HEX7 <= "0111111";
				
				-- Fetch Next Instruction
				IR <= SW; 
	
			when DECODE =>
			
				-- break down instruction
				OP <= IR(17 downto 15);
				Cloc <= IR(14 downto 10);
				Aloc <= IR(9 downto 5);
				Bloc <= IR(4 downto 0);
				
				-- Set Control Signals
				memReadA <= '1';
				memReadB <= '0';
				memWrite <= '0';
				
				-- Set Status Lights
				LEDG <= "0100";
				
				HEX0 <= hexOut(0);
				HEX1 <= hexOut(1);
				HEX2 <= (others => '1');
				HEX3 <= hexOut(3);
				HEX4 <= hexOut(4);
				HEX5 <= hexOut(5);
				HEX6 <= hexOut(6);
				HEX7 <= hexOut(7);
				
				hexIn(0) <= PC(3 downto 0);
				hexIn(1) <= "000" & PC(4);
				hexIn(3) <= "0" & OP;
				hexIn(4) <= Bloc(3 downto 0);
				hexIn(5) <= "000" & Bloc(4);
				hexIn(6) <= Aloc(3 downto 0);
				hexIn(7) <= "000" & Aloc(4);
				
			when READB =>
			
				-- Set Control Signals
				memReadA <= '0';
				memReadB <= '1';
				memWrite <= '0';
				
				-- Set Status Lights
				LEDG <= "0110";
				
				HEX0 <= hexOut(0);
				HEX1 <= hexOut(1);
				HEX2 <= (others => '1');
				HEX3 <= hexOut(3);
				HEX4 <= hexOut(4);
				HEX5 <= hexOut(5);
				HEX6 <= hexOut(6);
				HEX7 <= hexOut(7);
				
				hexIn(0) <= PC(3 downto 0);
				hexIn(1) <= "000" & PC(4);
				hexIn(3) <= "0" & OP;
				hexIn(4) <= Bloc(3 downto 0);
				hexIn(5) <= "000" & Bloc(4);
				hexIn(6) <= Aloc(3 downto 0);
				hexIn(7) <= "000" & Aloc(4);
				
			when EXECUTE =>
			
				-- Set Control Signals
				memReadA <= '0';
				memReadB <= '0';
				memWrite <= '0';
			
				-- Determine Result with ALU
				ALUA <= A;
				ALUB <= B;
				C <= ALUC;
				
				-- Set Status Lights
				LEDG <= "0010";
				
				HEX0 <= hexOut(0);
				HEX1 <= hexOut(1);
				HEX2 <= hexOut(2);
				HEX3 <= hexOut(3);
				HEX4 <= hexOut(4);
				HEX5 <= hexOut(5);
				HEX6 <= hexOut(6);
				HEX7 <= hexOut(7);
				
				hexIn(0) <= PC(3 downto 0);
				hexIn(1) <= "000" & PC(4);
				hexIn(2) <= C(3 downto 0);
				hexIn(3) <= C(7 downto 4);
				hexIn(4) <= B(3 downto 0);
				hexIn(5) <= B(7 downto 4);
				hexIn(6) <= A(3 downto 0);
				hexIn(7) <= A(7 downto 4);
				
			when MEMORY =>
			
				-- Set Control Signals
				memReadA <= '0';
				memReadB <= '0';
				memWrite <= '1';
				
				-- Set Status Lights
				LEDG <= "0001";
				
				HEX0 <= hexOut(0);
				HEX1 <= hexOut(1);
				HEX2 <= hexOut(2);
				HEX3 <= hexOut(3);
				HEX4 <= (others => '1');
				HEX5 <= (others => '1');
				HEX6 <= hexOut(6);
				HEX7 <= hexOut(7);
				
				hexIn(0) <= PC(3 downto 0);
				hexIn(1) <= "000" & PC(4);
				hexIn(2) <= C(3 downto 0);
				hexIn(3) <= C(7 downto 4);
				hexIn(6) <= Cloc(3 downto 0);
				hexIn(7) <= "000" & Cloc(4);
				
			when IMMEDIATE =>
			
				-- Set Control Signals
				memReadA <= '0';
				memReadB <= '0';
				memWrite <= '1';
				
				-- Set Status Lights
				LEDG <= "1111";
				
				C <= SW(12 downto 5);
				Cloc <= SW(4 downto 0);
				
				HEX0 <= (others => '1');
				HEX1 <= (others => '1');
				HEX2 <= hexOut(2);
				HEX3 <= hexOut(3);
				HEX4 <= (others => '1');
				HEX5 <= (others => '1');
				HEX6 <= hexOut(6);
				HEX7 <= hexOut(7);
				
				hexIn(2) <= C(3 downto 0);
				hexIn(3) <= C(7 downto 4);
				hexIn(6) <= Cloc(3 downto 0);
				hexIn(7) <= "000" & Cloc(4);
				
				
			when others => null;
	
		end case;
	
	end process;
	
end fsm;