-- --- from lab instructions pages 9 to 11
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_voltmeter IS
END tb_voltmeter;

ARCHITECTURE behavior OF tb_voltmeter IS

    COMPONENT Voltmeter IS
    PORT(
			clk, reset : IN std_logic;
			S	 : in  STD_LOGIC; --controls mux	
            S2   : in  STD_LOGIC;
		    LEDR : OUT std_logic_vector (9 downto 0);
		    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : OUT std_logic_vector (7 downto 0)
    );
    END COMPONENT;
    
	 signal clk,reset,S : std_logic;
	 signal LEDR : std_logic_vector (9 downto 0);
	 signal HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : std_logic_vector (7 downto 0);
    
    BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: Voltmeter PORT MAP (
			clk => clk,
			reset => reset,
			S => S,
			S2 => '0',
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
