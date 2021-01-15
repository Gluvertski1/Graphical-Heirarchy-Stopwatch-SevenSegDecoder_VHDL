-- Jared Day
-- 9/18/17

-- Seven Segment Display Lab

-- This program will use the four switches on the FPGA board to 
-- control the output on the seven segment display on the board.

-- THIS ONE HAS a decimal point

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sevensegdec IS
PORT(		
		i_A		: IN std_logic_vector(3 DOWNTO 0);
		o_OUT		: OUT std_logic_vector(7 DOWNTO 0));
END sevensegdec;

ARCHITECTURE ckt OF sevensegdec IS
	BEGIN
		WITH i_A SELECT
		
		o_OUT <= "01000000" WHEN "0000",
					"01111001" WHEN "0001",
					"00100100" WHEN "0010",
					"00110000" WHEN "0011",
					"00011001" WHEN "0100",
					"00010010" WHEN "0101",
					"00000010" WHEN "0110",
					"01111000" WHEN "0111",
					"00000000" WHEN "1000",
					"00011000" WHEN "1001",
					"00001000" WHEN "1010",
					"00000011" WHEN "1011",
					"01000110" WHEN "1100",
					"00100001" WHEN "1101",
					"00000110" WHEN "1110",
					"00001110" WHEN "1111";
END ckt;