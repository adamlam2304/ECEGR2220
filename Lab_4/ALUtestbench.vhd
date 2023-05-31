LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testALU_vhd IS
END testALU_vhd;

ARCHITECTURE behavior OF testALU_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ALU
		Port(	DataIn1: in std_logic_vector(31 downto 0);
			DataIn2: in std_logic_vector(31 downto 0);
			ALUCtrl: in std_logic_vector(4 downto 0);
			Zero: out std_logic;
			ALUResult: out std_logic_vector(31 downto 0) );
	end COMPONENT ALU;

	--Inputs
	SIGNAL datain_a : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL datain_b : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL control	: std_logic_vector(4 downto 0)	:= (others=>'0');

	--Outputs
	SIGNAL result   :  std_logic_vector(31 downto 0);
	SIGNAL zeroOut  :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: ALU PORT MAP(
		DataIn1 => datain_a,
		DataIn2 => datain_b,
		ALUCtrl => control,
		Zero => zeroOut,
		ALUResult => result
	);
	

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Non-Immediate Value
		datain_a <= X"1D100002";	-- DataIn in hex
		datain_b <= X"108108EF";
		control  <= "00000";	-- Control in binary (ADD and ADDI test)
		wait for 20 ns; 			-- result = 0x2D9108F1  and zeroOut = 0
		control  <= "00001";	-- Subtraction
		wait for 20 ns; 			-- result = 0x0C8EF713  and zeroOut = 0
		control <= "00010"; 	-- AND
		wait for 20 ns; 			-- result = 0x10000002  and zeroOut = 0
		control <= "00011"; 	-- OR
		wait for 20 ns; 			-- result = 0x1D9108EF  and zeroOut = 0
		control <= "00101"; 	-- Shift right by one
		wait for 20 ns; 			-- result = 0x0E880001  and zeroOut = 0
		control <= "00110";     -- Shift right by two
		wait for 20 ns; 			-- result = 0x07440000  and zeroOut = 0
		control <= "00111";     -- Shift right by three
		wait for 20 ns; 			-- result = 0x03A20000  and zeroOut = 0
		control <= "01001";     -- Shift left by one
		wait for 20 ns; 			-- result = 0x3A200004  and zeroOut = 0
		control <= "01010";     -- Shift left by two
		wait for 20 ns; 			-- result = 0x74400008  and zeroOut = 0
		control <= "01011";     -- Shift left by three
		wait for 20 ns; 			-- result = 0xE8800010  and zeroOut = 0
		
		-- Immediate Values
		datain_b <= X"00000123"; -- (Immediate value)
		control <= "10000"; 	-- ADDI
		wait for 20 ns; 		-- result = 0x1D100125  and zeroOut = 0
		control <= "10010";	-- ANDI
		wait for 20 ns; 		-- result = 0x00000002  and zeroOut = 0
		control <= "10011";	-- ORI
		wait for 20 ns; 		-- result = 0x1D100123  and zeroOut = 0
		control <= "10111";	-- SRLI by three
		wait for 20 ns; 		-- result = 0x03A20000  and zeroOut = 0
		control <= "11011";	-- SLLI by three
		wait for 20 ns;                 -- result = 0xE8800010
			
		-- Testing zero output
		datain_a <= X"108108EF";  -- New Data to test zero output
		datain_b <= X"108108EF";
		control <= "00001";	-- Subtraction
		wait for 20 ns; 		-- result = 0x00000000  and zeroOut = 1


		wait; -- will wait forever
	END PROCESS;

END;

