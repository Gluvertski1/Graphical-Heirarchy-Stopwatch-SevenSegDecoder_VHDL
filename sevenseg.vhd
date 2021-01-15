-- Jared Day
-- 9/18/17

-- Seven Segment Display Lab

-- This program will use the four switches on the FPGA board to 
-- control the output on the seven segment display on the board.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sevenseg IS
PORT(		
		i_A		: IN std_logic_vector(3 DOWNTO 0);
		o_OUT		: OUT std_logic_vector(6 DOWNTO 0));
END sevenseg;

ARCHITECTURE ckt OF sevenseg IS
	BEGIN

		WITH i_A SELECT
		
		o_OUT <= "1000000" WHEN "0000",
					"1111001" WHEN "0001",
					"0100100" WHEN "0010",
					"0110000" WHEN "0011",
					"0011001" WHEN "0100",
					"0010010" WHEN "0101",
					"0000010" WHEN "0110",
					"1111000" WHEN "0111",
					"0000000" WHEN "1000",
					"0011000" WHEN "1001",
					"0001000" WHEN "1010",
					"0000011" WHEN "1011",
					"1000110" WHEN "1100",
					"0100001" WHEN "1101",
					"0000110" WHEN "1110",
					"0001110" WHEN "1111";
		
END ckt;
