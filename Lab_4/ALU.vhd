--------------------------------------------------------------------------------
--
-- LAB #4
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0);
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(	datain: in std_logic_vector(31 downto 0);
		   	dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;

	signal carry: std_logic;
	signal output_add_sub : std_logic_vector(31 downto 0);
	signal output_shift : std_logic_vector(31 downto 0);
	signal output_and : std_logic_vector(31 downto 0);
	signal output_or : std_logic_vector(31 downto 0);


	-- Immediates
	signal output_add_sub_i: std_logic_vector(31 downto 0);
	signal output_shift_i : std_logic_vector(31 downto 0);
	signal output_and_i : std_logic_vector(31 downto 0);
	signal output_or_i : std_logic_vector(31 downto 0);	


	-- Additional Signals
	signal addorsub : std_logic;
	signal output_temp: std_logic_vector(31 downto 0);

begin
	-- Add ALU VHDL implementation here
	
	with ALUCtrl select
		addorsub <= '0' when "00000", -- add
			    '0' when "10000",	
			    '1' when others; -- sub



	-- Non-immediates
	c1: adder_subtracter port map(DataIn1, DataIn2, addorsub, output_add_sub, carry);
	c2: shift_register port map(DataIn1, ALUCtrl(2), ALUCtrl, output_shift);
	output_and <= DataIn1 AND DataIn2;
	output_or <= DataIn1 OR DataIn2;
	


	-- Immediates
	c3: adder_subtracter port map(DataIn1, DataIn2, addorsub, output_add_sub_i, carry);
	c4: shift_register port map(DataIn1, ALUCtrl(2), ALUCtrl, output_shift_i);
	output_and_i <= DataIn1 AND DataIn2;
	output_or_i <= DataIn1 OR DataIn2;
	

	with ALUCtrl select
		output_temp <= output_add_sub when "00000",
			     output_add_sub when "00001",
			     output_and when "00010",
			     output_or when "00011",
			     output_shift when "00101",
 			     output_shift when "00110",
                             output_shift when "00111",
                             output_shift when "01001",
                             output_shift when "01010",
                             output_shift when "01011",
                             ---------Immediates-----------
			     output_add_sub_i when "10000",
			     output_and_i when "10010",
			     output_or_i when "10011",
			     output_shift_i when "10101",
 			     output_shift_i when "10110",
                             output_shift_i when "10111",
                             output_shift_i when "11001",
                             output_shift_i when "11010",
                             output_shift_i when "11011",
			     DataIn2 when others;

	ALUResult <= output_temp;
	with output_temp select
		Zero <= '1' when x"00000000",
			'0' when others;

end architecture ALU_Arch;
	
	



