library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity downcounter is
 Generic ( period : natural := 1000); -- number to count       
    PORT ( clk    : in  STD_LOGIC; -- clock to be divided
           reset  : in  STD_LOGIC; -- active-high reset
           enable : in  STD_LOGIC; -- active-high enable
           zero   : out STD_LOGIC; -- creates a positive pulse every time current_count hits zero
                                   -- useful to enable another device, like to slow down a counter
           value  : out STD_LOGIC_VECTOR(integer(ceil(log2(real(period)))) - 1 downto 0) -- outputs the current_count value, if needed
         );
end downcounter;

architecture Behavioral of downcounter is
  signal current_count : natural;
  
BEGIN
   
   count: process(clk) begin
     if (rising_edge(clk)) then 
       if (reset = '1') then 
          current_count <= 0 ;
          zero          <= '0';
       elsif (enable = '1') then 
          if (current_count = 0) then
            current_count <= period - 1;
            zero          <= '1';
          else 
            current_count <= current_count - 1;
            zero          <= '0';
          end if;
       else 
          zero <= '0';
       end if;
     end if;
   end process;
   
   value <= std_logic_vector(to_signed(current_count, value'length)); 
   
END Behavioral;
