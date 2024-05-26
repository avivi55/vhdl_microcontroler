-- Code your testbench here
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity instructions_wave is

end entity;

architecture instructions_wave_arch of instructions_wave is

    component instructions is
        port (
            clock : in std_logic;
            program_choice : in std_logic_vector (1 downto 0);

            function_selection : out std_logic_vector (3 downto 0);
            route_selection : out std_logic_vector (3 downto 0);
            output_selection : out std_logic_vector (1 downto 0)
        );
    end component;

    signal clock_sim : std_logic := '0';
    signal function_selection_sim : std_logic_vector (3 downto 0);
    signal route_selection_sim : std_logic_vector (3 downto 0);
    signal output_selection_sim : std_logic_vector (1 downto 0);

    signal program_choice_sim : std_logic_vector (1 downto 0) := "00";

    constant PERIOD : time := 100 us;

begin

    clk : process
    begin
    	clock_sim <= '0';
        wait for 0.5*PERIOD;
        clock_sim <= '1';
        wait for 0.5*PERIOD;

        if now = 10*PERIOD then
        	program_choice_sim <= "01";
        end if;

        if now = 128*PERIOD then
        	wait;
        end if;
    end process;

    test_component : instructions
    port map (
    	clock => clock_sim,
        program_choice => program_choice_sim,
        function_selection => function_selection_sim,
        route_selection => route_selection_sim,
        output_selection => output_selection_sim
    );

end architecture;
