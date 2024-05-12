-- Code your testbench here
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity instructions_test is

end entity;

architecture instructions_test_arch of instructions_test is

    component instructions_buf is
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

    signal test_clk_sig: integer := 0;
    signal tests_finished: boolean := false;

    procedure test(test: boolean; name: string) is
    begin
        if test then 
            report name & ": test passed.";
        else 
            report name & ": test failed !" severity error;
        end if;        
    end procedure;

begin

    clk : process
    begin
    	clock_sim <= '0';
        wait for 0.5*PERIOD;
        clock_sim <= '1';
        wait for 0.5*PERIOD;

        if tests_finished = true then
        	wait;
        end if;
    end process;

    test_clk_sig <= test_clk_sig + 1 when rising_edge(clock_sim) else test_clk_sig;

    test_component : instructions_buf
    port map (
    	clock => clock_sim,
        program_choice => program_choice_sim,
        function_selection => function_selection_sim,
        route_selection => route_selection_sim,
        output_selection => output_selection_sim
    );

    program_choice_sim <= "00";

    tests : process(test_clk_sig)
    begin

        if test_clk_sig = 1 then
            test(function_selection_sim = "0000", "function selection 1");
            test(route_selection_sim = "0000", "route selection 1");
            test(output_selection_sim = "00", "output selection 1");
        end if;

        if test_clk_sig = 2 then
            test(function_selection_sim = "0000", "function selection 2");
            test(route_selection_sim = "0001", "route selection 2");
            test(output_selection_sim = "00", "output selection 2");
        end if;

        if test_clk_sig = 3 then
            test(function_selection_sim = "1111", "function selection 3");
            test(route_selection_sim = "0110", "route selection 3");
            test(output_selection_sim = "00", "output selection 3");
        end if;

        if test_clk_sig = 4 then
            test(function_selection_sim = "0000", "function selection 4");
            test(route_selection_sim = "0110", "route selection 4");
            test(output_selection_sim = "01", "output selection 4");

            tests_finished <= true;
        end if;

    end process;

end architecture;
