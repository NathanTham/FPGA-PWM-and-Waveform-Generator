library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Voltmeter is
    Port ( clk                           : in  STD_LOGIC;
           reset                         : in  STD_LOGIC;
           S									  : in  STD_LOGIC; --controls mux
           S2                            : in  STD_LOGIC; --controls lo or high distance
			  s3									  : in  STD_LOGIC; --wavecontrol sawtooth 
			  s4									  : in  STD_LOGIC; --wavecontrol triangle
			  s5									  : in  STD_LOGIC; --wavecontrol square
			  s6									  : in  STD_LOGIC; --frequency/amplitude select
			  but0								  : in  STD_LOGIC; --amplitude select
			  but1								  : in  STD_LOGIC; --amplitude select
           PWM_OUTWAVE                   : out STD_LOGIC;
			  PWM_BUZ_OUTWAVE					  : out STD_LOGIC; -- buzzer
           LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0)
          );

end Voltmeter;

architecture Behavioral of Voltmeter is

Signal A, Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5 :   STD_LOGIC_VECTOR (3 downto 0):= (others=>'0');
Signal DP_in:   STD_LOGIC_VECTOR (5 downto 0);
Signal ADC_read,rsp_data,q_outputs_1,q_outputs_2 : STD_LOGIC_VECTOR (11 downto 0);
Signal voltage: STD_LOGIC_VECTOR (12 downto 0);
Signal busy: STD_LOGIC;
signal response_valid_out_i1,response_valid_out_i2,response_valid_out_i3 : STD_LOGIC_VECTOR(0 downto 0);
Signal bcd: STD_LOGIC_VECTOR(15 DOWNTO 0);
signal SevenSegInput: STD_LOGIC_VECTOR(15 DOWNTO 0);
Signal multoutput : STD_LOGIC_VECTOR(12 downto 0);
Signal Q_temp1 : std_logic_vector(11 downto 0);
Signal v2doutput : std_logic_vector(12 downto 0);
Signal muxoutput : std_logic_vector(12 downto 0);
Signal pulse1m : std_logic;
Signal pulse500k : std_logic;
Signal pulse333k : std_logic;
Signal pulse250k : std_logic;
Signal pulse200k : std_logic;
Signal pulse125k : std_logic;
Signal pulse111k : std_logic;
Signal pulse63k : std_logic;
Signal pulse40k : std_logic;
Signal pulse37k : std_logic;
Signal pulse31k : std_logic;
Signal pulse16k : std_logic;
Signal pulse12k : std_logic;
Signal pulse8k : std_logic;
Signal pulse4k : std_logic;
Signal pulse2k : std_logic;
Signal pulse1k : std_logic;
Signal dbut0,dbut1 : std_logic;

Component SevenSegment is
    Port( Num_Hex0,Num_Hex1,Num_Hex2,Num_Hex3,Num_Hex4,Num_Hex5 : in  STD_LOGIC_VECTOR (3 downto 0);
          Hex0,Hex1,Hex2,Hex3,Hex4,Hex5                         : out STD_LOGIC_VECTOR (7 downto 0);
          DP_in                                                 : in  STD_LOGIC_VECTOR (5 downto 0)
			);
End Component ;

Component adc_conversion is
    Port( MAX10_CLK1_50      : in STD_LOGIC;
          response_valid_out : out STD_LOGIC;
          ADC_out            : out STD_LOGIC_VECTOR (11 downto 0)
         );
End Component ;

Component binary_bcd IS
   PORT(
      clk     : IN  STD_LOGIC;                      --system clock
      reset   : IN  STD_LOGIC;                      --active low asynchronus reset
      ena     : IN  STD_LOGIC;                      --latches in new binary number and starts conversion
      binary  : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);  --binary number to convert
      busy    : OUT STD_LOGIC;                      --indicates conversion in progress
      bcd     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)   --resulting BCD number
		);
END Component;

Component synchronizer is
   generic(numReg : integer; syncBits : integer);
	port
     (
      clk       : in  std_logic;
      reset     : in  std_logic;
      enable    : in  std_logic;
      d_inputs  : in  std_logic_vector(syncBits-1 downto 0);
      q_outputs : out std_logic_vector(syncBits-1 downto 0)
     );
END Component;

Component averager is
	port (
			clk, reset : in std_logic;
			Din : in  std_logic_vector(11 downto 0);
			EN  : in  std_logic; -- response_valid_out
			Q   : out std_logic_vector(11 downto 0)
			);
  end Component;

Component Mux is
	port (
			S  : in 	std_logic;
			W1 : in 	std_logic_vector(12 downto 0);
			W2 : in 	std_logic_vector(12 downto 0);
			OP : out	std_logic_vector(12 downto 0)
			);
end Component;

Component voltage2distance is
	port (
			clk            :  IN    STD_LOGIC;
			reset          :  IN    STD_LOGIC;
			S              :  IN    STD_LOGIC;
			voltage        :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);
			distance       :  OUT   STD_LOGIC_VECTOR(12 DOWNTO 0)
			);
end Component;

Component wave_gen is
	port ( 
			reset 			: in STD_LOGIC;
         clk				: in STD_LOGIC;
			freq1m			: in STD_LOGIC;
			freq500k			: in STD_LOGIC; 
			freq333k			: in STD_LOGIC;
			freq250k			: in STD_LOGIC;
			freq200k			: in STD_LOGIC;
			freq125k			: in STD_LOGIC;
			freq111k			: in STD_LOGIC;
			freq63k			: in STD_LOGIC;
			freq40k 			: in STD_LOGIC;
			freq37k			: in STD_LOGIC;
			freq31k			: in STD_LOGIC;
			freq16k			: in STD_LOGIC;
			freq12k			: in STD_LOGIC;
			freq8k			: in STD_LOGIC;
			freq4k			: in STD_LOGIC;
         freq2k			: in STD_LOGIC;
			freq1k			: in STD_LOGIC;
			ampfrequp 		: in STD_LOGIC;
			ampfreqdown 	: in STD_LOGIC;
			sawsel		 	: in STD_LOGIC;
			trianglesel  	: in STD_LOGIC;
			squaresel  		: in STD_LOGIC;
			ampfreqsel 		: in STD_LOGIC;
         PWM_OUT 			: out STD_LOGIC
         );
end Component;

component wave_gen_buzzer is
    Port ( reset 			: in STD_LOGIC;
           clk				: in STD_LOGIC;
			  freq1m			: in STD_LOGIC;
			  freq500k		: in STD_LOGIC; 
			  freq333k		: in STD_LOGIC;
			  freq250k		: in STD_LOGIC;
			  freq200k		: in STD_LOGIC;
			  freq125k		: in STD_LOGIC;
			  freq111k		: in STD_LOGIC;
			  freq63k		: in STD_LOGIC;
			  freq40k 		: in STD_LOGIC;
			  freq37k		: in STD_LOGIC;
			  freq31k		: in STD_LOGIC;
			  freq16k		: in STD_LOGIC;
			  freq12k		: in STD_LOGIC;
			  freq8k			: in STD_LOGIC;
			  freq4k			: in STD_LOGIC;
           freq2k			: in STD_LOGIC;
			  freq1k			: in STD_LOGIC;
			  ampfreqsel   : in STD_LOGIC;
			  distance		: in STD_LOGIC_VECTOR(11 downto 0);
           PWM_OUT 		: out STD_LOGIC
          );
end Component;

Component clock_divider is
	port ( 
			clk      		: in  STD_LOGIC;
         reset    		: in  STD_LOGIC;
         enable   		: in  STD_LOGIC;
			frequency1m		: out STD_LOGIC;
			frequency500k 	: out STD_LOGIC;
			frequency333k 	: out STD_LOGIC;
			frequency250k 	: out STD_LOGIC;
			frequency200k 	: out STD_LOGIC;
			frequency125k 	: out STD_LOGIC;
			frequency111k 	: out STD_LOGIC;
			frequency63k 	: out STD_LOGIC;
			frequency40k 	: out STD_LOGIC;
			frequency37k 	: out STD_LOGIC;
			frequency31k 	: out STD_LOGIC;
			frequency16k 	: out STD_LOGIC;
			frequency12k 	: out STD_LOGIC;
			frequency8k 	: out STD_LOGIC;
			frequency4k 	: out STD_LOGIC;
         frequency2k 	: out STD_LOGIC;
			frequency1k 	: out STD_LOGIC
         );
end Component;
 
Component debouncer1 is
	port (
		clk		: IN  STD_LOGIC; 
		reset   	: IN  STD_LOGIC;
		D_IN  	: IN  STD_LOGIC; --button
		SP  		: OUT STD_LOGIC    --result
		);
end Component; 

begin
   Num_Hex0 <= SevenSegInput(3  downto  0);
   Num_Hex1 <= SevenSegInput(7  downto  4);
   Num_Hex2 <= SevenSegInput(11 downto  8);
   Num_Hex3 <= "1111" when bcd(15 downto 12) = "0000" and (S = '1' and not(muxoutput = "0000000000000")) else -- blank 3rd display when value is zero
               SevenSegInput(15 downto 12);
   Num_Hex4 <= "1010" when muxoutput = "0000000000000" and S = '1' else
               "1111";  -- blank this display
   Num_Hex5 <= "1111";  -- blank this display
   DP_in (5 downto 4) <= "00"; -- position of the decimal point in the display
	DP_in (3) <= not S;
	DP_in (2) <= S;
   DP_in (1 downto 0) <= "00";
   SevenSegInput <= "1011101111001011" when muxoutput = "0000000000000" and S = '1' else --when S = 1
                     bcd(15 downto 0);
							
debounce0 : debouncer1
			 port map(
				clk => clk,
				D_IN => but0,
				reset => reset,
				SP => dbut0
				);
				
debounce1 : debouncer1
			 port map(
				clk => clk,
				D_IN => but1,
				reset => reset,
				SP => dbut1
				);
							
pulse : clock_divider
          port map(
            clk => clk,
            reset => reset,
            enable => '1',
				frequency1m => pulse1m,
			   frequency500k => pulse500k,
				frequency333k => pulse333k,
			   frequency250k => pulse250k,
				frequency200k => pulse200k,
			   frequency125k => pulse125k,
				frequency111k => pulse111k,
			   frequency63k => pulse63k,
				frequency40k => pulse40k, 
				frequency37k => pulse37k,
			   frequency31k => pulse31k,
			   frequency16k => pulse16k,
				frequency12k => pulse12k,
			   frequency8k => pulse8k,
			   frequency4k => pulse4k,
            frequency2k => pulse2k,
				frequency1k => pulse1k
            );
				
buzzer :wave_gen_buzzer
			 port map(
				reset 		=> reset,
            clk 			=> clk,
            freq1m		=> pulse1m,
				freq500k		=> pulse500k, 
				freq333k		=> pulse333k,
				freq250k		=> pulse250k,
				freq200k		=> pulse200k,
				freq125k		=> pulse125k,
				freq111k		=> pulse111k,
				freq63k		=> pulse63k,
				freq40k 		=> pulse40k,
				freq37k		=> pulse37k,
				freq31k		=> pulse31k,
				freq16k		=> pulse16k,
				freq12k		=> pulse12k,
				freq8k		=> pulse8k,
				freq4k		=> pulse4k,
				freq2k		=> pulse2k,
				freq1k		=> pulse1k,
				ampfreqsel	=> s6,
				distance    => Q_temp1,
            PWM_OUT 		=> PWM_BUZ_OUTWAVE
            );
				
wave : wave_gen
          port map(
            reset 		=> reset,
            clk 			=> clk,
            freq1m		=> pulse1m,
				freq500k		=> pulse500k, 
				freq333k		=> pulse333k,
				freq250k		=> pulse250k,
				freq200k		=> pulse200k,
				freq125k		=> pulse125k,
				freq111k		=> pulse111k,
				freq63k		=> pulse63k,
				freq40k 		=> pulse40k,
				freq37k		=> pulse37k,
				freq31k		=> pulse31k,
				freq16k		=> pulse16k,
				freq12k		=> pulse12k,
				freq8k		=> pulse8k,
				freq4k		=> pulse4k,
				freq2k		=> pulse2k,
				freq1k		=> pulse1k,
				ampfrequp 	=> dbut0,
				ampfreqdown => dbut1,
				sawsel 		=> s3,
				trianglesel => s4,
				Squaresel 	=> s5,
				ampfreqsel	=> s6,
            PWM_OUT 		=> PWM_OUTWAVE
            );

ave :    averager
			 port map(
				clk       => clk,
				reset     => reset,
				Din       => q_outputs_2,
				EN        => response_valid_out_i3(0),
				Q         => Q_temp1
				);

distance_selector: Mux
			 port map(
				S  	=>	S,     --when 0, averaged value is selected, when 1, non averaged value selected.
				W1		=>	multoutput,
				W2		=>	v2doutput,
				OP		=>	muxoutput
				);

v2dconverter: voltage2distance
			 port map(
				clk  		=> clk,
            reset    => reset,
            S        => S2,
				voltage  => multoutput,
				distance => v2doutput
				);

sync1 : synchronizer
			 generic map(numReg => 3, syncBits => 12)
			 port map(
				clk       => clk,
            reset     => reset,
            enable    => '1',
            d_inputs  => ADC_read,
            q_outputs => q_outputs_2
            );

sync2 : synchronizer
			 generic map(numReg => 3, syncBits => 1)
			 port map(
				clk       => clk,
            reset     => reset,
            enable    => '1',
            d_inputs  => response_valid_out_i1,
            q_outputs => response_valid_out_i3
            );

SevenSegment_ins: SevenSegment
			 port map( 
				Num_Hex0 => Num_Hex0,
            Num_Hex1 => Num_Hex1,
            Num_Hex2 => Num_Hex2,
            Num_Hex3 => Num_Hex3,
            Num_Hex4 => Num_Hex4,
            Num_Hex5 => Num_Hex5,
            Hex0     => Hex0,
            Hex1     => Hex1,
            Hex2     => Hex2,
            Hex3     => Hex3,
            Hex4     => Hex4,
            Hex5     => Hex5,
            DP_in    => DP_in
            );

ADC_Conversion_ins:  adc_conversion  PORT MAP(
                                     MAX10_CLK1_50       => clk,
                                     response_valid_out  => response_valid_out_i1(0),
                                     ADC_out             => ADC_read);

LEDR(9 downto 0) <=Q_temp1(11 downto 2); -- gives visual display of upper binary bits to the LEDs on board

-- in line below, can change the scaling factor (i.e. 2500), to calibrate the voltage reading to a reference voltmeter
voltage <= std_logic_vector(resize(unsigned(Q_temp1)*2500*2/4096,voltage'length));  -- Converting ADC_read a 12 bit binary to voltage readable numbers
multoutput <= voltage(12 downto 0);

binary_bcd_ins: binary_bcd
   PORT MAP(
      clk      => clk,
      reset    => reset,
      ena      => '1',
      binary   => muxoutput,
      busy     => busy,
      bcd      => bcd
      );
end Behavioral;
