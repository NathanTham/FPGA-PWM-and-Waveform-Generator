LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.math_real.all;

ENTITY SquareLUT IS
   PORT(
      clk					:  IN    STD_LOGIC;
      reset             :  IN    STD_LOGIC;
      ampup					:  IN		STD_LOGIC;
		ampdown				:  IN    STD_LOGIC;
      squareamp         :  OUT   STD_LOGIC_VECTOR(8 DOWNTO 0)
		);
END SquareLUT;

ARCHITECTURE behavior OF SquareLUT IS

signal index : integer := 5;

type array_1d is array (0 to 5) of integer;
constant square : array_1d := (
(	50	)  ,
(  100)  ,
(  200)  ,
(  300)  ,
(  400)  ,
(  500)
);

begin
   selector : process(ampup, ampdown, reset, clk)
	begin
		if (reset = '1') then
			index <= 0;
			if (ampup = '0') then
				index <= index + 1;
			end if;
			if (ampdown = '0') then
				index <= index - 1;
			end if;
		end if;
	end process;

   squareamp <= std_logic_vector(to_unsigned((square(index)),squareamp'length));

end behavior;
