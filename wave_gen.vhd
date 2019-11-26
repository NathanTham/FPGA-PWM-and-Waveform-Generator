library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.all;

entity wave_gen is
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
			  ampfrequp 	: in STD_LOGIC;
			  ampfreqdown 	: in STD_LOGIC;
			  sawsel		 	: in STD_LOGIC;
			  trianglesel  : in STD_LOGIC;
			  squaresel  	: in STD_LOGIC;
			  ampfreqsel 	: in STD_LOGIC;
           PWM_OUT 		: out STD_LOGIC
          );
end wave_gen;

architecture Behavioral of wave_gen is
 
    constant width	: integer:= 9;
    signal pwm_out_i	: STD_LOGIC;
    signal duty_cycle,dcsaw,dctri,dcsquare,counter	: STD_LOGIC_VECTOR(width-1 downto 0);
	 signal indextriangle,indexsquare, indexsawtooth : STD_LOGIC_VECTOR(15 downto 0);
    constant max_count: std_logic_vector(width-1 downto 0) := (others => '1');  
    constant zeros_count : std_logic_vector(width-1 downto 0) := (others => '0');  
	 signal intsquareamp : std_logic_vector(8 downto 0);   
	 signal incrementsquare : STD_LOGIC;
	 signal pulse,ampup,ampdown : STD_LOGIC;
	 signal freqindex : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
	 signal ampindex	: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	 
	component SawtoothLUT is
		port(
			clk				:  IN    STD_LOGIC;                                
			reset          :  IN    STD_LOGIC; 
			index          :  IN    STD_LOGIC_VECTOR (15 DOWNTO 0);                                                          
			sawtoothdc     :  OUT   STD_LOGIC_VECTOR(8 DOWNTO 0)
			);  
	end Component;
	 
	component upcountersaw is
		Generic ( period : natural := 1000); -- number to count       
		port(
			clk				: in  STD_LOGIC; -- clock to be divided
			reset  			: in  STD_LOGIC; -- active-high reset
			enable 			: in  STD_LOGIC; -- active-high enable
			value  			: out STD_LOGIC_VECTOR(15 downto 0) -- outputs the current_count value, if needed
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
			index					:  IN 	STD_LOGIC_VECTOR(3 DOWNTO 0);
			squareamp         :  OUT   STD_LOGIC_VECTOR(8 DOWNTO 0)
			);
	end component;
	
	component upcountersquare is
		PORT ( 
			clk    : in  STD_LOGIC; 
         reset  : in  STD_LOGIC; 
         enable : in  STD_LOGIC; 
         value  : out STD_LOGIC 
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
	
	component downcountersquare is
		Generic ( period : natural := 1000); -- number to count       
		PORT ( 
			clk    : in  STD_LOGIC; -- clock to be divided
         reset  : in  STD_LOGIC; -- active-high reset
         enable : in  STD_LOGIC; -- active-high enable
         zero   : out STD_LOGIC -- creates a positive pulse every time current_count hits zero
                                   -- useful to enable another device, like to slow down a counter
         );
	end component;
   
begin
	sawtooth : SawtoothLUT
		port map (
			clk => clk,
			reset => reset,
			index => indexsawtooth,
			sawtoothdc => dcsaw
			);

	countsawtooth : upcountersaw
		generic map (period => 1024)
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
			triangledc => dctri
			);
		
	counttriangle : upcountertriangle
		generic map (period => 1024)
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
         duty_cycle => duty_cycle,
         pwm_out => pwm_out_i
         );
			
	sel : process (sawsel, trianglesel, squaresel)
		begin
			if (sawsel = '1') then
				duty_cycle <= dcsaw;
			end if;
			
			if (trianglesel = '1') then
				duty_cycle <= dctri;
			end if;
			
			if (squaresel = '1') then
				duty_cycle <= dcsquare;
			end if;
	end process;
	
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
	
	ampfreqselect : process (clk, reset) 
		begin 
			if (rising_edge(clk)) then
				if (reset ='1') then
					freqindex <= "00000";
					ampindex <= "0000";
					
				elsif (ampfreqsel = '0') then
					if (freqindex >= "10001") then
						freqindex <= "00000";
					elsif (ampfrequp = '0') then
						freqindex <= freqindex + "00001";
					elsif (ampfreqdown = '0') then
						freqindex <= freqindex - "00001";
					end if;
					
				elsif (ampfreqsel = '1') then
					if (ampfrequp = '0') then
						ampindex <= ampindex + "0001";
					elsif (ampfreqdown = '0') then
						ampindex <= ampindex - "0001";
					end if;
					
				end if;
			end if;
	end process; 
	
PWM_OUT <= pwm_out_i;		    
end Behavioral;
    