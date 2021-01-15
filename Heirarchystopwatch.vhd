-- Jared Day
-- 10/29/17

-- Heirarchy stopwatch. Same stopwatch but connections are made in VHDL (using the new way (VHDL -93)) to instantiate 
-- components. 

LIBRARY ieee;
LIBRARY altera;
LIBRARY compH;
USE ieee.std_logic_1164.ALL;
USE altera.altera_primitives_components.ALL;
USE compH.ALL;
--USE primitives.ALL;




ENTITY Heirarchystopwatch IS
GENERIC (N: INTEGER	:= 4);
PORT(
		i_clock					: IN std_logic;										-- system clock
		i_en						: IN std_logic;										-- system enable
		i_reset1					: IN std_logic;										-- reset for system
		o_ss1OUT					: OUT std_logic_vector(6 DOWNTO 0);				-- seven seg outputs
		o_ss2OUT					: OUT std_logic_vector(7 DOWNTO 0));			-- seven seg output with dec.
END Heirarchystopwatch;

ARCHITECTURE ckt OF Heirarchystopwatch IS
-- internal signals needed to connect submodules
SIGNAL w_oQ1			: std_logic_vector(N-1 DOWNTO 0);					-- the output Q's for the first seven seg dec.
SIGNAL w_oQ2			: std_logic_vector(N-1 DOWNTO 0);					-- the output Q's for the second seven seg dec.
SIGNAL w_max_tick1	: std_logic;								-- max tick for the first mod10counter goes to en of 2nd
SIGNAL r_jkffQ			: std_logic;								-- tied high for the jkff 
SIGNAL w_VCC			: std_logic;								-- vcc goes to PRN on jkff
SIGNAL w_j, w_k		: std_logic;								-- also tied high for j and k on jkff.
SIGNAL w_clock10hz	: std_logic;
SIGNAL w_clock10hz1	: std_logic;
SIGNAL w_reset			: std_logic;
BEGIN

-------------------------
w_VCC <= '1';															-- vcc is always high.
w_j <= '1';																-- tied high on jkff
w_k <= '1';																-- tied high on jkff
w_reset <= not(i_reset1);											-- inverted because of my code...
--------------------------

-- Use components to define submodules and parameters

clk_div: clockdivider1hz PORT MAP( 
												clock_50Mhz => i_clock,
												clock_10Hz => w_clock10hz,
												clock_1MHz => open,
												clock_100KHz => open,
												clock_10KHz => open,
												clock_1KHz => open,
												clock_100Hz => open,
												clock_1Hz => open
												);

BUFF1: global 				PORT MAP(												
												a_in => w_clock10hz,
												a_out => w_clock10hz1);
					
-- first mod 10
mod10_1:	mod10counter	PORT MAP(
											i_load => '0',
											i_d => (OTHERS => '0'),
											i_en =>r_jkffQ,					-- mapping the jkffq signal into the enable
											i_clk => w_clock10hz,			-- clock10hz signal into the clock
											i_reset => w_reset,				-- the reset (inverted) into the reset pin
											o_Q => w_oQ1,						-- outputs to the output Q signal
											max_tick => w_max_tick1);		-- max tick signal assigned to maxtick from mod10
	
-- second mod 10	
mod10_2: mod10counter	PORT MAP(
											i_load => '0',
											i_d => (OTHERS => '0'),
											max_tick => open,
											i_reset => w_reset,				-- reset into the reset pin
											i_clk => w_clock10hz,			-- 10 hz clock into the clk pin
											i_en => w_max_tick1,				-- max tick signal into the en of 2nd mod 10
											o_Q => w_oQ2 );						-- output Q's to the output Q signal

											
-- first seven seg decoder. no decimal point
sevseg1: sevenseg			PORT MAP(
											i_A => w_oQ1,						-- signal Q's into the input of decoder
											o_OUT => o_ss1OUT );				-- signal onto output pins
		
-- second seven seg decoder with decimal point.		
sevseg2: sevensegdec		PORT MAP(
											i_A => w_oQ2 ,						-- signal Q's into the input of decoder
											o_OUT => o_ss2OUT);				-- signal onto output pins
											
-- jk ff 									
jkff1: jkff					PORT MAP(
											j => w_VCC,
											k => w_VCC,
											clk => i_en,
											prn => w_VCC,
											clrn => i_reset1,
											q => r_jkffQ);
END ckt;
												
												
												
												