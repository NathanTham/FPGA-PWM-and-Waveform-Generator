-- averages 16 samples
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity averager is
	port (
		  clk   : in  std_logic;
		  EN    : in  std_logic;
		  reset : in  std_logic;
		  Din   : in  std_logic_vector(11 downto 0);
		  Q     : out std_logic_vector(11 downto 0));
	end averager;

architecture rtl of averager is

signal reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,reg16 : std_logic_vector(11 downto 0);
signal tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8,tmp9,tmp10,tmp11,tmp12,tmp13,tmp14,tmp15 : integer;
signal tmp16 : std_logic_vector(15 downto 0);

begin

shift_reg : process(clk, reset)
	begin
		if(reset = '1') then
			reg1  <= (others => '0');
			reg2  <= (others => '0');
			reg3  <= (others => '0');
			reg4  <= (others => '0');
			reg5  <= (others => '0');
			reg6  <= (others => '0');
			reg7  <= (others => '0');
			reg8  <= (others => '0');
			reg9  <= (others => '0');
			reg10 <= (others => '0');
			reg11 <= (others => '0');
			reg12 <= (others => '0');
			reg13 <= (others => '0');
			reg14 <= (others => '0');
			reg15 <= (others => '0');
			reg16 <= (others => '0');
			Q     <= (others => '0');
		elsif rising_edge(clk) then
			if EN = '1' then
				reg1  <= Din;
				reg2  <= reg1;
				reg3  <= reg2;
				reg4  <= reg3;
				reg5  <= reg4;
				reg6  <= reg5;
				reg7  <= reg6;
				reg8  <= reg7;				
				reg9  <= reg8;
				reg10 <= reg9;
				reg11 <= reg10;
				reg12 <= reg11;
				reg13 <= reg12;
				reg14 <= reg13;
				reg15 <= reg14;
				reg16 <= reg15;								
				Q     <= tmp16(15 downto 4); -- reg1; -- for testing
			end if;
		end if;
	end process shift_reg;

tmp1 <= to_integer(unsigned(reg1))  + to_integer(unsigned(reg2));
tmp2 <= to_integer(unsigned(reg3))  + to_integer(unsigned(reg4));  
tmp3 <= to_integer(unsigned(reg5))  + to_integer(unsigned(reg6));
tmp4 <= to_integer(unsigned(reg7))  + to_integer(unsigned(reg8));
tmp5 <= to_integer(unsigned(reg9))  + to_integer(unsigned(reg10));
tmp6 <= to_integer(unsigned(reg11)) + to_integer(unsigned(reg12));  
tmp7 <= to_integer(unsigned(reg13)) + to_integer(unsigned(reg14));
tmp8 <= to_integer(unsigned(reg15)) + to_integer(unsigned(reg16));

tmp9  <= tmp1 + tmp2;
tmp10 <= tmp3 + tmp4;
tmp11 <= tmp5 + tmp6;
tmp12 <= tmp7 + tmp8;

tmp13 <= tmp9  + tmp10;
tmp14 <= tmp11 + tmp12;

tmp15 <= tmp13 + tmp14;
		  
tmp16 <= std_logic_vector(to_unsigned(tmp15, tmp16'length)); 	
	
end rtl;
