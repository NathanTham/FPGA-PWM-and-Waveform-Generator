LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.math_real.all;
USE ieee.std_logic_unsigned.all;

entity Debouncer1 is
	Port ( 
		clk	: in std_logic;
		reset : in std_logic;
		D_IN : in std_logic;
		SP : out std_logic
		);
end Debouncer1;

architecture Behavioral of Debouncer1 is
signal QA, QB, Q, temp : std_logic;
begin
	process(clk)
		begin
	if rising_edge(clk) then
		if (reset = '1') then
		QA <= '0';
		QB <= '0';
		Q <= '0';
		else
		QA <= D_IN;
		QB <= QA;
		Q <= QB;
		end if;
	end if;
	end process;
temp <= QB and not Q;
SP <= not temp;
end Behavioral;
