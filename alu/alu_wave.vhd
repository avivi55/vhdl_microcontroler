library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity alu_wave is
end entity;

architecture alu_wave of alu_wave is

	component alu is
        port (
            a : in std_logic_vector (3 downto 0);
            b : in std_logic_vector (3 downto 0);
            function_selection : in std_logic_vector (3 downto 0);
            carries_received : in std_logic_vector (1 downto 0);
            carries_emitted : out std_logic_vector (1 downto 0);
            alu_output : out std_logic_vector (7 downto 0)
        );
    end component;

    signal a_sim, b_sim, sel_fct_sim : std_logic_vector (3 downto 0) := (others => '0');
    signal sr_in_sim : std_logic_vector (1 downto 0) := (others => '0');
    signal sr_out_sim : std_logic_vector (1 downto 0);
    signal s_sim : std_logic_vector (7 downto 0);

begin

    test_component : alu
    port map ( 
    	a => a_sim,
        b => b_sim,
        function_selection => sel_fct_sim,
        carries_received => sr_in_sim,
        carries_emitted => sr_out_sim,
        alu_output => s_sim
    );

    proc : process	
    begin
        for fct in 0 to 15 loop
            for a in -8 to 7 loop
                for b in -8 to 7 loop
                    for sr in 0 to 3 loop
                        sel_fct_sim <= std_logic_vector(to_unsigned(fct,4));
                        a_sim <= std_logic_vector(to_signed(a,4));
                        b_sim <= std_logic_vector(to_signed(b,4));
                        sr_in_sim <= std_logic_vector(to_unsigned(sr,2));
                        
                        wait for 100 us;
                    end loop;
                end loop;
            end loop;
        end loop;
        wait;      
    end process;

end architecture;
