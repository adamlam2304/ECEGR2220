--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
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
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;
	
	
--add more signals
	
	signal Instruction: std_logic_vector(31 downto 0);
	signal address: std_logic_vector(31 downto 0);
	signal Branch : STD_LOGIC_VECTOR(1 downto 0);
        signal MemRead : STD_LOGIC;
        signal MemtoReg : STD_LOGIC;
        signal ALUCtrl : STD_LOGIC_VECTOR(4 downto 0);
        signal MemWrite : STD_LOGIC;
        signal ALUSrc : STD_LOGIC;
        signal RegWrite : STD_LOGIC;
        signal ImmGen : STD_LOGIC_VECTOR(1 downto 0);
	signal ReadData1: std_logic_vector(31 downto 0);
	signal ReadData2: std_logic_vector(31 downto 0);
	signal PCin: std_logic_vector(31 downto 0);
	signal PCout: std_logic_vector(31 downto 0);
	signal PCout4: std_logic_vector(31 downto 0);
	signal PCoutImm: std_logic_vector(31 downto 0);
	signal dataresult: std_logic_vector(31 downto 0);
	signal regresult : std_logic_vector(31 downto 0);
	signal immediate : std_logic_vector(31 downto 0);
	signal immediatecal: std_logic_vector(31 downto 0);
	signal immediatesave: std_logic_vector(31 downto 0);
	signal immediatebranch: std_logic_vector(31 downto 0);
	signal branchselect : std_logic;
	signal branchcalc : std_logic;
	signal Zero: std_logic;
	signal notZero: std_logic;
	signal ALUResult: std_logic_vector(31 downto 0);
	signal ReadData3: std_logic_vector(31 downto 0);


begin
	-- Add your code here
	
	inst: InstructionRAM port map (reset, clock, address(31 downto 2), Instruction);
		
	ctr: Control port map (clock, Instruction(6 downto 0), Instruction(14 downto 12), Instruction(31 downto 25), Branch, MemRead, MemtoReg, ALUCtrl, MemWrite, ALUSrc, RegWrite, ImmGen);
		
	regs: Registers port map (Instruction(24 downto 20), Instruction(19 downto 15), Instruction(11 downto 7), regresult, RegWrite, ReadData1, ReadData2);
		
	alum: ALU port map (ReadData1, dataresult, ALUCtrl, Zero, ALUResult);
		
	datamem: RAM port map (reset, clock, MemRead, MemWrite, ALUResult(31 downto 2), ReadData2, ReadData3);

	pc: ProgramCounter port map (reset, clock, PCin, PCout);

	alumux: BusMux2to1 port map (ALUSrc, ReadData2, immediate, dataresult);
		
	regmux: BusMux2to1 port map (MemtoReg, ALUResult, ReadData3, regresult);
		
	pcmux: BusMux2to1 port map (branchselect, PCout4, PCoutImm, PCin);

	PCout4 <= PCout + 4;

	PCoutImm <= PCout + immediate;

	immediatesave <= (x"00000" & Instruction(31 downto 25) & Instruction(11 downto 7));

	immediatebranch <= ("0000000000000000000" & Instruction(31) & Instruction(7) & Instruction(30 downto 25) & Instruction(11 downto 8) & "0");

	immediatecal <= (x"00000" & Instruction(31 downto 20));

	with instruction(6 downto 0) select
		immediate <= immediatesave when "0100011",
			     immediatebranch when "1100011", 
			     immediatecal when others;

	notZero <= not Zero;

	with Branch select
		branchselect <= Zero when "01",
				notZero when others;
end holistic;

