-- This is example code that uses the downcounter module to create the signals
-- to drive the 7-segment displays for a countdown timer. This code is
-- provided to you to show an example of how to use the downcounter module,
-- if it is of use to your project.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity clock_divider is
    PORT ( clk      : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           enable   : in  STD_LOGIC;
			  frequency1m : out STD_LOGIC;
			  frequency500k : out STD_LOGIC;
			  frequency250k : out STD_LOGIC;
			  frequency125k : out STD_LOGIC;
			  frequency63k : out STD_LOGIC;
			  frequency31k : out STD_LOGIC;
			  frequency16k : out STD_LOGIC;
			  frequency8k : out STD_LOGIC;
			  frequency4k : out STD_LOGIC;
           frequency2k : out STD_LOGIC;
			  frequency1k : out STD_LOGIC
           );
end clock_divider;

architecture Behavioral of clock_divider is
-- Signals:
signal internal1m : STD_LOGIC; 
signal internal500k : STD_LOGIC;
signal internal250k : STD_LOGIC;
signal internal125k : STD_LOGIC;
signal internal63k : STD_LOGIC;
signal internal31k : STD_LOGIC;
signal internal16k : STD_LOGIC;
signal internal8k : STD_LOGIC;
signal internal4k : STD_LOGIC;
signal internal2k : STD_LOGIC;
signal internal1k : STD_LOGIC;

-- Components declarations
component downcounter is
   Generic ( period  : natural := 1000); -- number to count
      PORT (  clk    : in  STD_LOGIC;
              reset  : in  STD_LOGIC;
              enable : in  STD_LOGIC;
              zero   : out STD_LOGIC;
              value  : out STD_LOGIC_VECTOR(integer(ceil(log2(real(period)))) - 1 downto 0)
           );
end component;

BEGIN

	oneMHzpulse: downcounter
	generic map (period=>50)
	port map(
               clk    => clk,	
               reset  => reset,
               enable => enable,
               zero   => internal1m,
               value  => open
            );
	
	fivehundredkHzpulse: downcounter
	generic map (period=>2)
	port map(
               clk    => clk,	
               reset  => reset,
               enable => internal1m,
               zero   => internal500k,
               value  => open
            );
				
	twohundredfiftykHzpulse: downcounter
	generic map (period=>2)
	port map(
               clk    => clk,	
               reset  => reset,
               enable => internal500k,
               zero   => internal250k,
               value  => open
            );
				
	onetwentyfivekHzpulse: downcounter
	generic map (period=>2)
	port map(
               clk    => clk,	
               reset  => reset,
               enable => internal250k,
               zero   => internal125k,
               value  => open
            );
				
	sixtythreekHzpulse: downcounter
	generic map (period=>2)
	port map(
               clk    => clk,	
               reset  => reset,
               enable => internal125k,
               zero   => internal63k,
               value  => open
            );
				
	thirtyonekHzpulse: downcounter
	generic map (period=>2)
	port map(
               clk    => clk,	
               reset  => reset,
               enable => internal63k,
               zero   => internal31k,
               value  => open
            );
				
	sixteenkHzpulse: downcounter
	generic map (period=>2)
	port map(
               clk    => clk,	
               reset  => reset,
               enable => internal31k,
               zero   => internal16k,
               value  => open
            );
				
	eightkHzpulse: downcounter
	generic map (period=>2)
	port map(
               clk    => clk,	
               reset  => reset,
               enable => internal16k,
               zero   => internal8k,
               value  => open
            );
				
	fourkHzpulse: downcounter
	generic map (period=>2)
	port map(
               clk    => clk,	
               reset  => reset,
               enable => internal8k,
               zero   => internal4k,
               value  => open
            );
	
   twokHzpulse: downcounter
   generic map(period => 2) 
   PORT MAP (
               clk    => clk,	
               reset  => reset,
               enable => internal4k,
               zero   => internal2k,
               value  => open 
            );
				
	onekHzpulse: downcounter
   generic map(period => 2) 
   PORT MAP (
               clk    => clk,	
               reset  => reset,
               enable => internal2k,
               zero   => internal1k,
               value  => open 
            );
    
  frequency1m <= internal1m;		
  frequency500k <= internal500k; 
  frequency250k <= internal250k;
  frequency125k <= internal125k;
  frequency63k <= internal63k;
  frequency31k <= internal31k;
  frequency16k <= internal16k;
  frequency8k <= internal8k;
  frequency4k <= internal4k;
  frequency2k <= internal2k;          
  frequency1k <= internal1k;
END Behavioral;
