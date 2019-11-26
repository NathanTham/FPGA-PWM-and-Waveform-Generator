LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY SquareLUT IS
   PORT(
      clk					:  IN    STD_LOGIC;
      reset             :  IN    STD_LOGIC;
      index					:  IN 	STD_LOGIC_VECTOR(3 DOWNTO 0);
      squareamp         :  OUT   STD_LOGIC_VECTOR(8 DOWNTO 0)
		);
END SquareLUT;

ARCHITECTURE behavior OF SquareLUT IS

type array_1d is array (0 to 15) of std_logic_vector(8 downto 0);

constant square : array_1d := (
(	"000000100"	)	,
(	"000011111"	)	,
(	"000111110"	)	,
(	"001011101"	)	,
(	"001111100"	)	,
(	"010011011"	)	,
(	"010111010"	)	,
(	"011011001"	)	,
(	"100010111"	)	,
(	"100110110"	)	,
(	"101010101"	)	,
(	"101110100"	)	,
(	"110010011"	)	,
(	"110110010"	)	,
(	"111010001"	)	,
(	"111111111"	)
);

begin

   squareamp <= square(to_integer(unsigned(index)));

end behavior;
