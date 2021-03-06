----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:10:06 05/07/2018 
-- Design Name: 
-- Module Name:    MRAM_GPR - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MRAM_GPR is
    Port ( RW : in  STD_LOGIC;
           ADR1 : in  STD_LOGIC_VECTOR (5 downto 0);
           ADR2 : in  STD_LOGIC_VECTOR (5 downto 0);
           ADRW : in  STD_LOGIC_VECTOR (5 downto 0);
           DINW : in  STD_LOGIC_VECTOR (7 downto 0);
           DOUT1 : out  STD_LOGIC_VECTOR (7 downto 0);
           DOUT2 : out  STD_LOGIC_VECTOR (7 downto 0));
end MRAM_GPR;

architecture Behavioral of MRAM_GPR is

-- 8-bit word subtype
subtype byte is std_logic_vector(7 downto 0);

-- 2D array type
type tRAM is array(0 to 63) of byte;

-- 2D RAM init
signal RAM: tRAM := (
	"00000000", -- 000000 - ZERO. Value is used for index initialization
	"00000001", -- 000001 - ONE. Value is used for index increment
	"00000000", -- 000010 - I (Array index)
	"00000101", -- 000011 - LEN (Length of array = 5)
	"00010000", -- 000100 - START. Value denotes address of the 1st element of array
	"00000000", -- 000101 - CUR. Value denotes address of current element of array
	"00011000", -- 000110 - RES_START. Value denotes address of the 1st resulting element (1st reverted element)
	"00000000", -- 000111 - RES_CUR. Value denotes address of current resulting element
	"00000000", -- 001000 - EMPTY. Address of empty (zero) value
	"00000000", -- 001001 - TMP_1
	"00000000", -- 001010 - TMP_2
	"00000000", -- 001011
	"00000000", -- 001100
	"00000000", -- 001101
	"00000000", -- 001110
	"00000000", -- 001111
	"00000001", -- 010000 - a[0]
	"00000011", -- 010001 - a[1]
	"00000111", -- 010010 - a[2]
	"00001111", -- 010011 - a[3]
	"01010101", -- 010100 - a[4]
	"00000000", -- 010101
	"00000000", -- 010110
	"00000000", -- 010111
	"00000000", -- 011000 - res[0]
	"00000000", -- 011001 - res[1]
	"00000000", -- 011010 - res[2]
	"00000000", -- 011011 - res[3]
	"00000000", -- 011100 - res[4]
	"00000000", -- 011101
	"00000000", -- 011110
	"00000000", -- 011111
	others => "00000000"
);

-- Input & output signals
signal d_in_w: byte;
signal d_out_1, d_out_2: byte;

begin

	-- Write process
	d_in_w <= DINW;
	WRITE: process(RW, ADRW, d_in_w)
	begin
		if RW = '0' then
			RAM(CONV_INTEGER(ADRW)) <= d_in_w;
		end if;
	end process;
	
	-- Read process
	d_out_1 <= RAM(CONV_INTEGER(ADR1));
	d_out_2 <= RAM(CONV_INTEGER(ADR2));
	ZBUFS: process (RW, d_out_1, d_out_2)
	begin
		if RW = '1' then
			DOUT1 <= d_out_1;
			DOUT2 <= d_out_2;
		else
			DOUT1 <= (others => 'Z');
			DOUT2 <= (others => 'Z');
		end if;
	end process;

end Behavioral;

