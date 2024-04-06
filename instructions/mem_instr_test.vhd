-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

entity mem_test is

end entity;

architecture mem_test_arch of mem_test is

	component mem is
        port (
            
        );
    end component;

begin

    test_component : mem
    port map ( 
    	
    );

    proc : process	
    begin        
    end process;

end architecture;
