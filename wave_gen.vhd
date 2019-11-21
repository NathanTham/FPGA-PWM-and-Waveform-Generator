library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.all;

entity wave_gen is
    Port ( reset 			: in STD_LOGIC;
           clk				: in STD_LOGIC;
           pulse 			: in STD_LOGIC;
			  ampup 			: in STD_LOGIC;
			  ampdown 		: in STD_LOGIC;
           PWM_OUT 		: out STD_LOGIC
          );
end wave_gen;

architecture Behavioral of wave_gen is

    constant up : STD_LOGIC := '1';
    constant down : STD_LOGIC := '0'; 
    constant width : integer:= 9;
    type StateType is (S0,S1,S2);
    signal CurrentState,NextState: StateType;
    signal pwm_out_i, count_direction : STD_LOGIC;
    signal duty_cycle,counter,indexsawtooth : STD_LOGIC_VECTOR(width-1 downto 0);
	 signal indextriangle,indexsquare : STD_LOGIC_VECTOR(15 downto 0);
    constant max_count: std_logic_vector(width-1 downto 0) := (others => '1');  
    constant zeros_count : std_logic_vector(width-1 downto 0) := (others => '0');  
	 signal intsquareamp : std_logic_vector(8 downto 0);   
	 
	component SawtoothLUT is
		port(
			clk				:  IN    STD_LOGIC;                                
			reset          :  IN    STD_LOGIC; 
			index          :  IN    STD_LOGIC_VECTOR (8 DOWNTO 0);                                                          
			sawtoothdc     :  OUT   STD_LOGIC_VECTOR(8 DOWNTO 0)
			);  
	end Component;
	 
	component upcountersaw is
		Generic ( period : natural := 1000); -- number to count       
		port(
			clk				: in  STD_LOGIC; -- clock to be divided
			reset  			: in  STD_LOGIC; -- active-high reset
			enable 			: in  STD_LOGIC; -- active-high enable
			value  			: out STD_LOGIC_VECTOR(8 downto 0) -- outputs the current_count value, if needed
         );
	end component;
	  
	component TriangleLUT is
		port(
			clk				:  IN    STD_LOGIC;                                
			reset          :  IN    STD_LOGIC; 
			index          :  IN    STD_LOGIC_VECTOR(15 DOWNTO 0);                                                          
			triangledc     :  OUT   STD_LOGIC_VECTOR(8 DOWNTO 0)
			);  
	end component;
	 
	component upcountertriangle is
		Generic ( period : natural := 1000);      
		port(
			clk				: in  STD_LOGIC; 
         reset  			: in  STD_LOGIC; 
         enable 			: in  STD_LOGIC; 
         value  			: out STD_LOGIC_VECTOR(15 downto 0) 
         );
	end component;
	
	component Squaregen is
		port(
			clk				: in STD_LOGIC;
			reset 			: in STD_LOGIC; 
			enable			: in STD_LOGIC;
			amp 				: in STD_LOGIC_VECTOR(8 downto 0);
			squaredc			: out STD_LOGIC_VECTOR(8 downto 0)
			);
	end component;
	
	component SquareLUT is
		port(
			clk					:  IN    STD_LOGIC;                                
			reset             :  IN    STD_LOGIC; 
			ampup					:  IN 	STD_LOGIC;
			ampdown				:  IN 	STD_LOGIC;
			squareamp         :  OUT   STD_LOGIC_VECTOR(8 DOWNTO 0)
			);
	end component;
	
	component PWM_DAC is
		Generic ( width : integer := 9);
      port (
			reset 			: in STD_LOGIC;
         clk				: in STD_LOGIC;
         duty_cycle 		: in STD_LOGIC_VECTOR(width-1 downto 0);
         pwm_out 			: out STD_LOGIC
         );
	end component;
	 
--	 component sawtoothwave is
--	 Port (  reset : in STD_LOGIC;
--           clk : in STD_LOGIC;
--           pulse :  in STD_LOGIC;
--           PWM_OUT : out STD_LOGIC
--          );
--	 end component;
 
    
    
begin
	sawtooth : SawtoothLUT
		port map (
			clk => clk,
			reset => reset,
			index => indexsawtooth,
			sawtoothdc => open --temp
			);

	countsawtooth : upcountersaw
		generic map (period => 1000)
		port map (
			clk => clk,
			reset => reset, 
			enable => pulse,
			value => indexsawtooth
			);
			
	triangle : TriangleLUT
		port map (
			clk => clk,
			reset => reset,
			index => indextriangle,
			triangledc => open --temp
			);
		
	counttriangle : upcountertriangle
		generic map (period => 1000)
		port map (
			clk => clk,
			reset => reset, 
			enable => pulse,
			value => indextriangle
			);
	
	square : Squaregen
		port map (
			clk => clk,
			reset => reset, 
			enable => pulse,
			amp => intsquareamp,
			squaredc => duty_cycle
			);
			
	ampmod : SquareLUT
		port map (
			clk => clk,
			reset => reset, 
			ampup => ampup,
			ampdown => ampdown,
			squareamp => intsquareamp
			);
			
	pwm : PWM_DAC 
		generic map (width => 9)
		port map (
			reset => reset,
         clk => clk,
         duty_cycle => duty_cycle,
         pwm_out => pwm_out_i
         );
		  
PWM_OUT <= pwm_out_i;		

--	sawtooth : sawtoothwave
--	port map (
--		reset => reset,
--		clk => clk, 
--		pulse => clk_1khz_pulse,
--		PWM_OUT => PWM_OUT
--		); 
--
--    pwm : PWM_DAC 
--    generic map (width => 9)
--    port map (
--        reset => reset,
--        clk => clk,
--        duty_cycle => duty_cycle,
--        pwm_out => pwm_out_i
--        );
--        
--    count : process(clk, reset, clk_1kHz_pulse, count_direction)
--        begin
--            if(reset = '1') then
--                counter <= zeros_count;
--            elsif (rising_edge(clk)) then 
--                if (clk_1kHz_pulse = '1') then
--                    if(count_direction = up) then
--                        counter <= counter + '1';
--                    else
--                        counter <= counter - '1';
--                    end if;                                                           
--                end if;
--            end if;
--        end process;
-- 
--    COMB : process(CurrentState, counter)
--    begin
--        case CurrentState is
--            when S0 =>
--                NextState <= S1;
--                duty_cycle <= zeros_count;
--                count_direction <= up;
--            when S1 =>
--                duty_cycle <= counter;
--                count_direction <= up;               
--                if counter = max_count then
--                    NextState <= S2;
--                else
--                    NextState <= S1;
--                end if;
--            when  S2 =>           
--                duty_cycle <= zeros_count ;
--                count_direction <= down;            
--                if counter = zeros_count then
--                    NextState <= S1;
--                else
--                    NextState <= S2;
--                end if;            
--            when others =>
--                NextState <= S0;
--                duty_cycle <= zeros_count;
--                count_direction <= up;                    
--        end case;
--    end process COMB;
--
--    SEQ : process(clk, reset)
--    begin
--      if(reset = '1') then
--         CurrentState <= S0;
--      elsif rising_edge(clk) then
--         CurrentState <= NextState;
--      end if;
--    end process SEQ;            
--        
end Behavioral;
    