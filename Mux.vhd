library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux is 
port (	
			S  : in 	std_logic;
			W1 : in 	std_logic_vector(12 downto 0);		
			W2 : in 	std_logic_vector(12 downto 0);
			OP : out	std_logic_vector(12 downto 0)
);
end Mux;

architecture behavior of Mux is
begin
	OP <= W1 when S = '0'
	else  W2;
end behavior; 
	