library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity dbus_wave is

end entity;

architecture dbus_wave_arch of dbus_wave is

	component dbus is
        port (
            -- Caches
            cache_1_received : in std_logic_vector (7 downto 0); -- from buffer
            cache_1_emitted : out std_logic_vector (7 downto 0);
            cache_1_enable : out std_logic;

            cache_2_received : in std_logic_vector (7 downto 0); -- from buffer
            cache_2_emitted : out std_logic_vector (7 downto 0);
            cache_2_enable : out std_logic;

            -- Selections
            outputting_selection : in std_logic_vector (1 downto 0); -- from buffer
            routing_selection : in std_logic_vector (3 downto 0);

            -- ALU (& input buffers)
            alu_output : in std_logic_vector (7 downto 0);

            a_buffer_enable : out std_logic;
            a_buffer : out std_logic_vector (3 downto 0);

            b_buffer_enable : out std_logic;
            b_buffer : out std_logic_vector (3 downto 0);

            -- Microcontroler I/O
            a_in : in std_logic_vector (3 downto 0);
            b_in : in std_logic_vector (3 downto 0);

            final_output : out std_logic_vector (7 downto 0)
        );
    end component;

    component nbuffer is
        generic (
            N : integer := 8
        );
        port (
            e1 : in std_logic_vector (N-1 downto 0);
            reset : in std_logic;
            enable : in std_logic;
            clock : in std_logic;
            s1 : out std_logic_vector (N-1 downto 0)
        );
    end component;

    signal cache_1_enable_sim, cache_2_enable_sim, a_buffer_enable_sim, b_buffer_enable_sim : std_logic := '0';
    signal output_selection_sim : std_logic_vector (1 downto 0) := "00";
    signal cache_1_emitted_sim, cache_1_received_sim, cache_2_received_sim, cache_2_emitted_sim, alu_output_sim, final_output_sim : std_logic_vector (7 downto 0) := "00000000";
    signal b_in_sim, a_in_sim, b_buffer_sim, a_buffer_sim, routing_selection_sim : std_logic_vector (3 downto 0) := "0000";

begin

    test_component : dbus
    port map (
        cache_1_received => cache_1_received_sim,
        cache_1_emitted => cache_1_emitted_sim,
        cache_1_enable => cache_1_enable_sim,
        cache_2_received => cache_2_received_sim,
        cache_2_emitted => cache_2_emitted_sim,
        cache_2_enable => cache_2_enable_sim,
        outputting_selection => output_selection_sim,
        routing_selection => routing_selection_sim,
        alu_output => alu_output_sim,
        a_buffer_enable => a_buffer_enable_sim,
        a_buffer => a_buffer_sim,
        b_buffer_enable => b_buffer_enable_sim,
        b_buffer => b_buffer_sim,
        a_in => a_in_sim,
        b_in => b_in_sim,
        final_output => final_output_sim
    );

    a_in_sim <= "0001";
    b_in_sim <= "0010";
    cache_1_received_sim <= "00000001";
    cache_2_received_sim <= "00000010";
    alu_output_sim <= "00000100";

    proc : process
    begin

        for route in 0 to 7 loop
            routing_selection_sim <= std_logic_vector(to_unsigned(route, 4));
            wait for 100 us;
        end loop;

        for route in 8 to 15 loop
            routing_selection_sim <= std_logic_vector(to_unsigned(route, 4));
            wait for 100 us;
        end loop;
        wait;

    end process;

    proc2 : process
    begin

        for outp in 0 to 3 loop
            output_selection_sim <= std_logic_vector(to_unsigned(outp, 2));
            wait for 100 us;
        end loop;
        wait;

    end process;

end architecture;
