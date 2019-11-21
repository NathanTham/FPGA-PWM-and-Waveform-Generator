library ieee;
use ieee.std_logic_1164.all;

entity synchronizer is 

generic(
        numReg : integer := 3;
        syncBits : integer := 1
       );

port(
        clk       : in  std_logic;
        reset     : in  std_logic;
        enable    : in  std_logic;
        d_inputs  : in  std_logic_vector(syncBits-1 downto 0);
        q_outputs : out std_logic_vector(syncBits-1 downto 0)
    );
end entity;

architecture Behavioral of synchronizer is 

type RegIOArray is array (0 to numReg) of std_logic_vector(syncBits-1 downto 0);
signal regIO : RegIOArray;

component registers is 
    generic(bits : integer);
    port( 
        clk       : in  std_logic;
        reset     : in  std_logic;
        enable    : in  std_logic;
        d_inputs  : in  std_logic_vector(bits-1 downto 0);
        q_outputs : out std_logic_vector(bits-1 downto 0)	
        );
end component;

begin
    regIO(0) <= d_inputs;

    q_outputs <= regIO(numReg);

    Gen_Registers: for i in 1 to numReg generate
        reg:    registers
            generic map(bits => syncBits)
            port map
            (
                clk         => clk,
                reset       => reset,
                enable      => enable,
                d_inputs    => regIO(i-1),
                q_outputs   => regIO(i)
            );
    end generate Gen_Registers; 
end Behavioral;