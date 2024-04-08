-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

entity instructions_buf_test is

end entity;

architecture instructions_buf_test_arch of instructions_buf_test is

    component instructions_buf is
        port (
            clock : in std_logic;

            function_selection : out std_logic_vector (3 downto 0);
            route_selection : out std_logic_vector (3 downto 0);
            output_selection : out std_logic_vector (1 downto 0)
        );
    end component;

    signal clock_sim : std_logic;
    signal function_selection_sim : std_logic_vector (3 downto 0);
    signal route_selection_sim : std_logic_vector (3 downto 0);
    signal output_selection_sim : std_logic_vector (1 downto 0);

    constant PERIOD : time := 100 us;

begin

    clk : process
    begin
    	clock_sim <= '0';
        wait for 0.5*PERIOD;
        clock_sim <= '1';
        wait for 0.5*PERIOD;

        if now = 3*PERIOD then
        	wait;
        end if;
    end process;

    test_component : instructions_buf
    port map (
    	clock => clock_sim,
        function_selection => function_selection_sim,
        route_selection => route_selection_sim,
        output_selection => output_selection_sim
    );

    -- process
    -- begin
    --     wait;
    -- end process;

end architecture;
