library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity buffer_test is
end entity;

architecture buffer_test_arch of buffer_test is

    component nbuffer is
        generic (
            N : integer := 4
        );
        port (
            e1 : in std_logic_vector (N-1 downto 0);
            reset : in std_logic;
            enable : in std_logic;
            clock : in std_logic;
            s1 : out std_logic_vector (N-1 downto 0)
        );
    end component;

    constant N : integer := 4;

    constant PERIOD : time := 50 us;

    signal e1_sim, s1_sim : std_logic_vector(N-1 downto 0) := (others => '0');
    signal reset_sim, enable_sim, clock_sim : std_logic := '0';

begin

    test_component : nbuffer
    generic map (
    	N => N
    )
    port map (
    	e1 => e1_sim,
        reset => reset_sim,
        enable => enable_sim,
        clock => clock_sim,
        s1 => s1_sim
    );

    clk : process
    begin
    	clock_sim <= '0';
        wait for 0.8*PERIOD;
        clock_sim <= '1';
        wait for 0.2*PERIOD;

        if now = (8*(2**N))*PERIOD then
        	wait;
        end if;

    end process;


    proc : process
    begin

    	for i in 1 downto 0 loop
        	for j in 1 downto 0 loop
            	for k in 0 to (2**N)-1 loop
                   	e1_sim <= std_logic_vector(to_unsigned(k,N));
               		enable_sim <= to_unsigned(j,1)(0);
                    reset_sim <= to_unsigned(i,1)(0);
                 	wait for 2*PERIOD;
          		end loop;
            end loop;
        end loop;
        wait;

    end process;

end architecture;
