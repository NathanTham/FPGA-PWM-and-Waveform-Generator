--The problem that was in this file was that the reset input was missing from the sensitivity list of the process. 
--Reset must be in the sensitivity list, since events which determine the process are dependant on the value of reset.

library ieee;
use ieee.std_logic_1164.all;


entity registers is

generic(bits : integer := 1);
 
port( 
	  clk       : in  std_logic;
	  reset     : in  std_logic;
	  enable    : in  std_logic;
     d_inputs  : in  std_logic_vector(bits-1 downto 0);
	  q_outputs : out std_logic_vector(bits-1 downto 0)	
    );
end entity;

architecture rtl of registers is
begin

   process (clk, reset)
   begin
      if reset = '1' then
		   q_outputs <= (others=>'0');
		elsif (rising_edge(clk)) then
		   if (enable = '1') then
            q_outputs <= d_inputs;
			end if;
      end if;
   end process;

end;
