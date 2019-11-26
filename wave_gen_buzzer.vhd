library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.all;

entity wave_gen_buzzer is
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
end wave_gen_buzzer;

architecture Behavioural of wave_gen_buzzer is
	constant width	: integer:= 9;
	signal pwm_out_i	: STD_LOGIC;
	signal pulse : STD_LOGIC;
	signal freqindex : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
	signal ampindex	: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	signal intsquareamp : std_logic_vector(8 downto 0);   
	signal incrementsquare : STD_LOGIC;
	signal duty_cycle,dcsquare : STD_LOGIC_VECTOR(width-1 downto 0);

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
			index					:  IN 	STD_LOGIC_VECTOR(3 DOWNTO 0);
			squareamp         :  OUT   STD_LOGIC_VECTOR(8 DOWNTO 0)
			);
	end component;
	
	component downcountersquare is
		Generic ( period : natural := 1000); -- number to count       
		port ( 
			clk    : in  STD_LOGIC; 
         reset  : in  STD_LOGIC; 
         enable : in  STD_LOGIC; 
         zero   : out STD_LOGIC 
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

begin

	square : Squaregen
		port map (
			clk => clk,
			reset => reset, 
			enable => incrementsquare,
			amp => intsquareamp,
			squaredc => dcsquare
			);
			
	ampmod : SquareLUT
		port map (
			clk => clk,
			reset => reset, 
			index => ampindex,
			squareamp => intsquareamp
			);

	downcountsquare : downcountersquare
		generic map( period => 512 )
		port map (
			clk => clk,
			reset => reset,
			enable => pulse,
			zero => incrementsquare
			);
		
	pwm : PWM_DAC 
		generic map (width => 9)
		port map (
			reset => reset,
         clk => clk,
         duty_cycle => dcsquare,
         pwm_out => pwm_out_i
         );
	
	with freqindex select pulse <= freq1k		when "00000",
											 freq2k 		when "00001",
											 freq4k 		when "00010",
											 freq8k 		when "00011",
											 freq12k 	when "00100",
											 freq16k		when "00101",
											 freq31k		when "00110",
											 freq37k		when "00111",
											 freq40k 	when "01000",
											 freq63k		when "01001",
											 freq111k	when "01010",
											 freq125k  	when "01011",
											 freq200k 	when "01100",
											 freq250k	when "01101",
											 freq333k	when "01110",
											 freq500k 	when "01111",
											 freq1m		when "10000",
											 freq1k		when others;
											 
	ampfreqselectbuz : process (clk, reset)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				freqindex <= "00000";
				ampindex <= "0000";
			elsif (ampfreqsel = '0') then
				if (distance <= "000000000001") then
					freqindex <= "00000";
				elsif (distance <= "000011110000") then
					freqindex <= "00001";
				elsif (distance <= "000111100000") then
					freqindex <= "00010";
				elsif (distance <= "001011010000") then
					freqindex <= "00011";
				elsif (distance <= "001111000000") then
					freqindex <= "00100";	
				elsif (distance <= "010010110000") then
					freqindex <= "00101";	
				elsif (distance <= "010110100000") then
					freqindex <= "00110";	
				elsif (distance <= "011010010000") then
					freqindex <= "00111";	
				elsif (distance <= "011110000000") then
					freqindex <= "01000";
				elsif (distance <= "100001110000") then
					freqindex <= "01001";
				elsif (distance <= "100101100000") then
					freqindex <= "01010";
				elsif (distance <= "101001010000") then
					freqindex <= "01011";
				elsif (distance <= "101101000000") then
					freqindex <= "01100";
				elsif (distance <= "110000110000") then
					freqindex <= "01101";
				elsif (distance <= "110100100000") then
					freqindex <= "01110";	
				elsif (distance <= "111111110000") then
					freqindex <= "01111";
				elsif (distance <= "111111111111") then
					freqindex <= "10000";
				end if;
			
			elsif (ampfreqsel = '1') then
				if (distance <= "000100111011") then
					ampindex <= "0000";
				elsif (distance <= "001001110110") then
					ampindex <= "0001";
				elsif (distance <= "001110110001") then
					ampindex <= "0010";
				elsif (distance <= "010011101100") then
					ampindex <= "0011";
				elsif (distance <= "011000100111") then
					ampindex <= "0100";	
				elsif (distance <= "011101100010") then
					ampindex <= "0101";	
				elsif (distance <= "100000011101") then
					ampindex <= "0110";	
				elsif (distance <= "100001010000") then
					ampindex <= "0111";	
				elsif (distance <= "100001011111") then
					ampindex <= "1000";
				elsif (distance <= "100001101110") then
					ampindex <= "1001";
				elsif (distance <= "100010001001") then
					ampindex <= "1010";
				elsif (distance <= "100011010100") then
					ampindex <= "1011";
				elsif (distance <= "100111000000") then
					ampindex <= "1100";					
				end if;
					
				
			end if;
		end if;
	end process;
PWM_OUT <= pwm_out_i;			
end Behavioural; 
