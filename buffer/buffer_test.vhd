library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity buffer_test is
end entity;

architecture buffer_test_arch of buffer_test is

    component nbuffer is
        generic (
            N : integer := 2
        );
        port (
            e1 : in std_logic_vector (N-1 downto 0);
            reset : in std_logic;
            enable : in std_logic;
            clock : in std_logic;
            s1 : out std_logic_vector (N-1 downto 0)
        );
    end component;

    constant N : integer := 2;

    constant PERIOD : time := 100 us;

    signal e1_sim, s1_sim : std_logic_vector(N-1 downto 0) := (others => '0');
    signal reset_sim, enable_sim, clock_sim : std_logic := '0';

    signal test_clk_sig: integer := 0;
    signal test_tmp_sig: std_logic_vector(N-1 downto 0);
    signal tests_finished, test_enable_finished, test_reset_finished: boolean := false;


    procedure test(test: boolean; false_string: string; true_string: string) is
    begin
        if test then 
            report true_string;
        else 
            report false_string severity error;
        end if;        
    end procedure;


begin

    test_component : nbuffer
    generic map (
        N => 2
    )
    port map (
        e1 => e1_sim,
        reset => reset_sim,
        enable => enable_sim,
        clock => clock_sim,
        s1 => s1_sim
    );

    tests_finished <= test_enable_finished and test_reset_finished;

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

    test_clk_sig <= test_clk_sig + 1 when falling_edge(clock_sim) else test_clk_sig;

    tests : process(test_clk_sig)
    begin
        
        if test_clk_sig = 1 then
            enable_sim <= '1';
            e1_sim <= "10";
        end if;

        if test_clk_sig = 3 then
            assert s1_sim = "10" report "enable_on: test failed !" severity error;
            report "enable_on: test passed";
        end if;
        
        if test_clk_sig = 4 then
            enable_sim <= '0';
            e1_sim <= "11";
        end if;
        
        if test_clk_sig = 5 then
            assert  s1_sim = "10" report "enable_off: test failed !" severity error;
            report "enable_off: test passed";

            test_enable_finished <= true;
        end if;

        if test_clk_sig = 6 then
            reset_sim <= '1';
        end if;

        if test_clk_sig = 7 then
            test(s1_sim = "00", "reset: test failed !", "reset: test passed");

            test_reset_finished <= true;
        end if;

    end process;

end architecture;
