-- --- from lab instructions pages 9 to 11
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_voltmeter IS
END tb_voltmeter;

ARCHITECTURE behavior OF tb_voltmeter IS

    COMPONENT Voltmeter IS
    PORT(
			clk                           : in  STD_LOGIC;
			reset                         : in  STD_LOGIC;
			S						  	  : in  STD_LOGIC; --controls mux
			S2                         	  : in  STD_LOGIC; --controls lo or high distance
		    s3						  	  : in  STD_LOGIC; --wavecontrol sawtooth 
		    s4						  	  : in  STD_LOGIC; --wavecontrol triangle
		    s5						  	  : in  STD_LOGIC; --wavecontrol square
		    s6						  	  : in  STD_LOGIC; --frequency/amplitude select
		    but0						  : in  STD_LOGIC; --amplitude select
		    but1						  : in  STD_LOGIC; --amplitude select
			PWM_OUTWAVE                   : out STD_LOGIC;
		    PWM_BUZ_OUTWAVE				  : out STD_LOGIC; -- buzzer
			LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
			HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0)
    );
    END COMPONENT;
    
	 signal clk, reset, S, S2, s3,s4, s5, s6, but0, but1  : std_logic;
	 signal PWM_OUTWAVE, PWM_BUZ_OUTWAVE : std_logic;
	 signal LEDR : std_logic_vector (9 downto 0);
	 signal HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : std_logic_vector (7 downto 0);
    
    BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: Voltmeter PORT MAP (
			clk => clk,
			reset => reset,
			S => S,
			S2 => '0',
			s3 => s3,
			s4 => s4,
			s5 => s5,
			s6 => s6,
			but0 => but0,
			but1 => but1,
			PWM_OUTWAVE => PWM_OUTWAVE,
			PWM_BUZ_OUTWAVE => PWM_BUZ_OUTWAVE,
			LEDR => LEDR,
			HEX0 => HEX0,
			HEX1 => HEX1,
			HEX2 => HEX2,
			HEX3 => HEX3,
			HEX4 => HEX4,
			HEX5 => HEX5
    );
    
	-- Stimulus process here

    -- Stimulus process 
    clk_process : process
	 constant clk_period:time:=10 ns;
	 begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	 end process;

	Wave_type : process
constant clk_period:time:=10 ns;
	begin
		s3 <= '1'; --sawtooth
		s4 <= '0';
		s5 <= '0';
		wait for clk_period*200;
		s3 <= '0';
		s4 <= '1'; --triangle
		s5 <= '0';
		wait for clk_period*200;
		s3 <= '0';
		s4 <= '0';
		s5 <= '1'; --square
		wait for clk_period*200;
	end process; 
	
	AM_or_FM : process
constant clk_period:time:=10 ns;
	begin

		s6 <= '1';
		wait for clk_period*100;
		s6 <= '0';
		wait for clk_period*100;
	end process;

	Modulation : process
constant clk_period:time:=10 ns;
	begin

		but0 <= '1';
		wait for clk_period*3;
		but0 <= '1';
		wait for clk_period*3;
		but0 <= '1';
		wait for clk_period*3;
		but1 <= '1';
		wait for clk_period*3;
		but1 <= '1';
		wait for clk_period*3;
		but1 <= '1';
		wait for clk_period*3;
	end process;


	 mux_proc : process
	 begin
		S <= '0';
		wait for 150 ns;
		S <= '1';
		wait for 200 ns;
		S <= '0';
		wait;
	 end process;
	 
	 stim_proc : process 
	 begin
	 reset <= '0';
	 wait for 100 ns;
	 reset <= '1';
	 wait for 50 ns;
	 reset <= '0';
	 wait;
	 end process;



END;
