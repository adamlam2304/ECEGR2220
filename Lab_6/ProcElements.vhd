--------------------------------------------------------------------------------
--
-- LAB #6 - Processor Elements
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
			In0, In1: in std_logic_vector(31 downto 0);
			Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is
begin
-- Add your code here
	
	with selector select
	
		Result <= In0 when '0',
			  In1 when '1',
			  (others=>'Z') when others;
	
end architecture selection;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
      Port(clk : in  STD_LOGIC;
           opcode : in  STD_LOGIC_VECTOR (6 downto 0);
           funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
           funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
           Branch : out  STD_LOGIC_VECTOR(1 downto 0);
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
           ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
end Control;

architecture Boss of Control is
	
	--add signals
	
	signal funct10code: std_logic_vector (10 downto 0);
	signal opclock: std_logic_vector (7 downto 0);

begin
-- Add your code here
	
	
	
	funct10code <= funct7 & funct3 & opcode(4);
	opclock <= clk & opcode;

	with funct3 select
		Branch <= "01" when "000",
			  "10" when "001",
			  "00" when others;

	with opcode select
		MemRead <= '1' when "0000011",
			   '0' when others;

	with opcode select
		MemtoReg <= '1' when "0000011",
			    '0' when others;

	with funct10code select
		ALUCtrl <= "00000" when "00000000001",
			   "10000" when "10000000001",
			   "00001" when "00000001111",
			   "00010" when "00000001101",
			   "00011" when "00000000011",
			   "10011" when "00000001011",
			   "00100" when "----------0",
			   (others=>'Z') when others;

	with opclock select
		MemWrite <= '1' when "10100011",
			    '0' when others;

	with opcode select
		ALUSrc <= '0' when "0110011",
			  '1' when others;

	with opcode select
		RegWrite <= '0' when "1100011",
			    '0' when "0100011",
			    '1' when others;

	with opcode select
		ImmGen <= "00" when "0110011",
			  "01" when others;


end Boss;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;

architecture executive of ProgramCounter is
begin
-- Add your code here

	process (Clock)
	begin
		if (Reset = '1') then
			PCout <= x"00400000";
		elsif rising_edge(Clock) then
			PCout <= PCin;
		end if;
	end process;
end executive;
--------------------------------------------------------------------------------
