LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.math_real.all;
USE ieee.std_logic_unsigned.all;

ENTITY Squaregen is 
	PORT(
		clk				: in STD_LOGIC;
		reset 			: in STD_LOGIC; 
		enable			: in STD_LOGIC;
		amp 				: in STD_LOGIC_VECTOR(8 downto 0);
		squaredc			: out STD_LOGIC_VECTOR(8 downto 0)
		);
END Squaregen;
		
architecture Behavioural of Squaregen is
signal min : STD_LOGIC_VECTOR(8 downto 0) := "000000000";
signal dutycycle : STD_LOGIC_VECTOR (0 downto 0) := (others => '0');

begin 

with dutycycle select squaredc <= min when "0",
										    amp when "1";
												
switch : process(clk,reset,enable,amp)
	begin
		if(reset = '1') then
				dutycycle <= "0";	
		elsif (rising_edge(clk)) then
				if (enable = '1') then 
					dutycycle <= dutycycle + '1'; --overflow
				end if;	
		end if;	
end process;
			
		
end Behavioural;

