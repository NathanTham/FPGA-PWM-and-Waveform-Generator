LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY tb_PWM_DAC IS
END tb_PWM_DAC;

Architecture tb of tb_PWM_DAC is

component PWM_DAC
    Generic ( width : integer := 9);
    Port    ( reset      : in STD_LOGIC;
              clk        : in STD_LOGIC;
              duty_cycle : in STD_LOGIC_VECTOR (width-1 downto 0);
              pwm_out    : out STD_LOGIC
            );
end component;

   signal clk, reset, pwm_out : std_logic;
   signal duty_cycle : std_logic_vector(8 downto 0); -- must change to match width of instantiation width
   constant clk_period : time := 10 ns;  
  
begin

uut : PWM_DAC
         generic map (width => 9)
         port map(
                   reset      => reset,
                   clk        => clk,
                   duty_cycle => duty_cycle,
                   pwm_out    => pwm_out
                  );
			
   clk_process : process
   begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
   end process;
 
   reset_proc : process
   begin      
      reset <= '1';
      wait for 2*clk_period;   
      reset <= '0';
      wait;		
   end process;
		
   duty_cycle_proc: process
   begin      
      
      duty_cycle <= std_logic_vector(to_unsigned(5, duty_cycle'length));
      -- wait for 10*clk_period;   
      -- duty_cycle <= std_logic_vector(to_unsigned(7, duty_cycle'length));
      -- wait for 10*clk_period; 	
      -- duty_cycle <= std_logic_vector(to_unsigned(1, duty_cycle'length));
      -- wait for 10*clk_period; 	 
      -- duty_cycle <= std_logic_vector(to_unsigned(0, duty_cycle'length));
      -- wait for 10*clk_period; 	  
      wait;
   end process;	
					
end;	