library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity wave_gen is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
           clk_1kHz_pulse :  in STD_LOGIC;
           PWM_OUT : out STD_LOGIC
          );
end wave_gen;

architecture Behavioral of wave_gen is

    constant up : STD_LOGIC := '1';
    constant down : STD_LOGIC := '0'; 
    constant width : integer:= 9;
    type StateType is (S0,S1,S2);
    signal CurrentState,NextState: StateType;
    signal pwm_out_i, count_direction : STD_LOGIC;
    signal duty_cycle,counter : STD_LOGIC_VECTOR(width-1 downto 0);
    constant max_count: std_logic_vector(width-1 downto 0) := (others => '1');  
    constant zeros_count : std_logic_vector(width-1 downto 0) := (others => '0');   
 
    component PWM_DAC is
        Generic ( width : integer := 9);
        Port (    reset : in STD_LOGIC;
                  clk : in STD_LOGIC;
                  duty_cycle : in STD_LOGIC_VECTOR(width-1 downto 0);
                  pwm_out : out STD_LOGIC
              );
     end component;
    
begin

    pwm : PWM_DAC 
    generic map (width => 9)
    port map (
        reset => reset,
        clk => clk,
        duty_cycle => duty_cycle,
        pwm_out => pwm_out_i
        );
        
    count : process(clk, reset, clk_1kHz_pulse, count_direction)
        begin
            if(reset = '1') then
                counter <= zeros_count;
            elsif (rising_edge(clk)) then 
                if (clk_1kHz_pulse = '1') then
                    if(count_direction = up) then
                        counter <= counter + '1';
                    else
                        counter <= counter - '1';
                    end if;                                                           
                end if;
            end if;
        end process;
 
    COMB : process(CurrentState, counter)
    begin
        case CurrentState is
            when S0 =>
                NextState <= S1;
                duty_cycle <= zeros_count;
                count_direction <= up;
            when S1 =>
                duty_cycle <= counter;
                count_direction <= up;               
                if counter = max_count then
                    NextState <= S2;
                else
                    NextState <= S1;
                end if;
            when  S2 =>           
                duty_cycle <= zeros_count;
                count_direction <= down;            
                if counter = zeros_count then
                    NextState <= S1;
                else
                    NextState <= S2;
                end if;            
            when others =>
                NextState <= S0;
                duty_cycle <= zeros_count;
                count_direction <= up;                    
        end case;
    end process COMB;

    SEQ : process(clk, reset)
    begin
      if(reset = '1') then
         CurrentState <= S0;
      elsif rising_edge(clk) then
         CurrentState <= NextState;
      end if;
    end process SEQ;            
        
    PWM_OUT <= pwm_out_i;

end Behavioral;
    