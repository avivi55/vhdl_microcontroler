library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;


entity microcontroler_test is
end entity;


architecture microcontroler_test_arch of microcontroler_test is

    component microcontroler is
        port (
            clock : in std_logic;
            reset : in std_logic;
            a_in : in std_logic_vector (3 downto 0);
            b_in : in std_logic_vector (3 downto 0);
            carries_received : in std_logic_vector (1 downto 0);
            final_output : out std_logic_vector (7 downto 0);
            carries_emitted : out std_logic_vector (1 downto 0)
        );
    end component;

    signal clock_sim : std_logic := '0';
    signal reset_sim : std_logic := '0';
    signal a_in_sim : std_logic_vector (3 downto 0);
    signal b_in_sim : std_logic_vector (3 downto 0);
    signal carries_received_sim : std_logic_vector (1 downto 0);
    signal final_output_sim : std_logic_vector (7 downto 0);
    signal carries_emitted_sim : std_logic_vector (1 downto 0);

    constant period : time := 100 us;

begin

    test_component : microcontroler
    port map (
        clock => clock_sim,
        reset => reset_sim,
        a_in => a_in_sim,
        b_in => b_in_sim,
        carries_received => carries_received_sim,
        final_output => final_output_sim,
        carries_emitted => carries_emitted_sim
    );

    clk : process
    begin
    	clock_sim <= '0';
        wait for 0.5*PERIOD;
        clock_sim <= '1';
        wait for 0.5*PERIOD;

        if now = 120*PERIOD then
        	wait;
        end if;

    end process;


    proc : process
    begin

    	a_in_sim <= "0101";
    	b_in_sim <= "0011";
        carries_received_sim <= "00";

        wait;

    end process;



end architecture;