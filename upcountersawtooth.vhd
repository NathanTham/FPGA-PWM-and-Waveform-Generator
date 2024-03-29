library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_unsigned.all;

entity upcountersaw is
 Generic ( period : natural := 1000); -- number to count       
    PORT ( clk    : in  STD_LOGIC; -- clock to be divided
           reset  : in  STD_LOGIC; -- active-high reset
           enable : in  STD_LOGIC; -- active-high enable
           value  : out STD_LOGIC_VECTOR(15 downto 0) -- outputs the current_count value, if needed
         );
end upcountersaw;

architecture Behavioral of upcountersaw is
  signal current_count : STD_LOGIC_VECTOR(15 downto 0);
  
BEGIN
   
   count: process(clk) begin
     if (rising_edge(clk)) then 
       if (reset = '1') then 
          current_count <= (others => '0') ;
       elsif (enable = '1') then 
          current_count <= current_count + '1';
       end if;
     end if;
   end process;
   
   value <= current_count; 
   
END Behavioral;