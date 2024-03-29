library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity sawtoothwave is
	Port (  reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           pulse :  in STD_LOGIC;
           PWM_OUT : out STD_LOGIC
          );
end sawtoothwave;

architecture Behavioural of sawtoothwave is 
    constant width : integer:= 9;
    constant max_count: std_logic_vector(width-1 downto 0) := (others => '1');  
    constant zeros_count : std_logic_vector(width-1 downto 0) := (others => '0');
	 signal duty_cycle : std_logic_vector(width-1 downto 0); 
	 
	 component PWM_DAC is
        Generic ( width : integer := 9);
        Port (    reset : in STD_LOGIC;
                  clk : in STD_LOGIC;
                  duty_cycle : in STD_LOGIC_VECTOR(width-1 downto 0);
                  pwm_out : out STD_LOGIC
              );
     end component;
	  
	  component upcounter is
			Generic ( period : natural := 1000); -- number to count       
			PORT ( clk    : in  STD_LOGIC; -- clock to be divided
					 reset  : in  STD_LOGIC; -- active-high reset
					 enable : in  STD_LOGIC; -- active-high enable
					 value  : out STD_LOGIC_VECTOR(8 downto 0) -- outputs the current_count value, if needed
         );
	  end component;
	  
	  begin
	  
	  pwm : PWM_DAC 
     generic map (width => 9)
     port map (
        reset => reset,
        clk => clk,
        duty_cycle => duty_cycle,
        pwm_out => PWM_OUT
        );
		
		count : upcounter
		generic map (period => 1000)
		port map (
			clk => clk,
			reset => reset, 
			enable => pulse,
			value => duty_cycle
			);
			
end Behavioural;