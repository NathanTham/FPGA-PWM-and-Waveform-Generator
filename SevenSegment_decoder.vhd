-- --- Seven segment component
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SevenSegment_decoder is
    Port ( 
           H     : out STD_LOGIC_VECTOR (7 downto 0);
           input : in  STD_LOGIC_VECTOR (3 downto 0);
           DP    : in  STD_LOGIC 
			 );
end SevenSegment_decoder;

architecture Behavioral of SevenSegment_decoder is
begin
   Process (input)
   begin
      Case input is                             -- 7-Segment Display:
         when "0000" => H(6 downto 0)<="1000000"; -- 0  
         when "0001" => H(6 downto 0)<="1111001"; -- 1
         when "0010" => H(6 downto 0)<="0100100"; -- 2
         when "0011" => H(6 downto 0)<="0110000"; -- 3
         when "0100" => H(6 downto 0)<="0011001"; -- 4
         when "0101" => H(6 downto 0)<="0010010"; -- 5
         when "0110" => H(6 downto 0)<="0000010"; -- 6
         when "0111" => H(6 downto 0)<="1111000"; -- 7
         when "1000" => H(6 downto 0)<="0000000"; -- 8
         when "1001" => H(6 downto 0)<="0011000"; -- 9
         when "1010" => H(6 downto 0)<="0000110"; -- E
         when "1011" => H(6 downto 0)<="0101111"; -- r
         when "1100" => H(6 downto 0)<="0100011"; -- 0
         When others => H(6 downto 0)<="1111111"; -- blank display
      End Case;
   End Process;
   
   Process (DP)
   begin
      if (DP='0') then
         H(7)<='1'; 
      else
         H(7)<='0';
      end if;
   End Process;
    
end Behavioral;
