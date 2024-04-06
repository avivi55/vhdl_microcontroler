library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

entity mem is
    port (
        clock : in std_logic;
        reset : in std_logic;

        SEL_FCT : out std_logic_vector (3 downto 0);
        SEL_ROUTE : out std_logic_vector (3 downto 0);
        SEL_OUT : out std_logic_vector (1 downto 0);
    );
end entity;

architecture mem_arch of mem is

begin

    proc: process() 
    begin
        
    end process;

end architecture;