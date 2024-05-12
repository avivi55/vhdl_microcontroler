library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity dbus_test is

end entity;

architecture dbus_test_arch of dbus_test is

	component dbus is
        port (
            -- Caches
            cache_1_received : in std_logic_vector (7 downto 0); -- from buffer
            cache_1_emmited : out std_logic_vector (7 downto 0);
            cache_1_enable : out std_logic;
            
            cache_2_received : in std_logic_vector (7 downto 0); -- from buffer
            cache_2_emmited : out std_logic_vector (7 downto 0);
            cache_2_enable : out std_logic;
    
            -- Selections
            outputing_selection : in std_logic_vector (1 downto 0); -- from buffer
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
    signal cache_1_emmited_sim, cache_1_received_sim, cache_2_received_sim, cache_2_emmited_sim, alu_output_sim, final_output_sim : std_logic_vector (7 downto 0) := "00000000";
    signal b_in_sim, a_in_sim, b_buffer_sim, a_buffer_sim, routing_selection_sim : std_logic_vector (3 downto 0) := "0000";

    procedure test(test: boolean; name: string) is
    begin
        if test then 
            report name & ": test passed.";
        else 
            report name & ": test failed !"  severity error;
        end if;        
    end procedure;

begin

    test_component : dbus
    port map ( 
        cache_1_received => cache_1_received_sim,
        cache_1_emmited => cache_1_emmited_sim,
        cache_1_enable => cache_1_enable_sim,
        cache_2_received => cache_2_received_sim,
        cache_2_emmited => cache_2_emmited_sim,
        cache_2_enable => cache_2_enable_sim,
        outputing_selection => output_selection_sim,
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
    cache_1_received_sim <= "10000101";
    cache_2_received_sim <= "01000110";
    alu_output_sim <= "00100111";

    tests : process
        variable current_route: integer := 0;
        variable current_output: integer := 0;
    begin

        wait for 1 us;
        test(
            a_buffer_sim = "0001" and
            a_buffer_enable_sim = '1' and

            b_buffer_enable_sim = '0' and
            cache_1_enable_sim = '0' and
            cache_2_enable_sim = '0',
            "a in buf a"
        );

        current_route := current_route + 1;
        routing_selection_sim <= std_logic_vector(to_unsigned(current_route, 4));

        wait for 1 us;
        test(
            b_buffer_sim = "0010" and
            b_buffer_enable_sim = '1' and

            a_buffer_enable_sim = '0' and
            cache_1_enable_sim = '0' and
            cache_2_enable_sim = '0',
            "b in buf b"
        );

        current_route := current_route + 1;
        routing_selection_sim <= std_logic_vector(to_unsigned(current_route, 4));

        wait for 1 us;
        test(
            a_buffer_sim = "0111" and
            a_buffer_enable_sim = '1' and

            b_buffer_enable_sim = '0' and
            cache_1_enable_sim = '0' and
            cache_2_enable_sim = '0',
            "s in buf a (LSB)"
        );

        current_route := current_route + 1;
        routing_selection_sim <= std_logic_vector(to_unsigned(current_route, 4));

        wait for 1 us;
        test(
            a_buffer_sim = "0010" and
            a_buffer_enable_sim = '1' and

            b_buffer_enable_sim = '0' and
            cache_1_enable_sim = '0' and
            cache_2_enable_sim = '0',
            "s in buf a (MSB)"
        );

        current_route := current_route + 1;
        routing_selection_sim <= std_logic_vector(to_unsigned(current_route, 4));

        wait for 1 us;
        test(
            b_buffer_sim = "0111" and
            b_buffer_enable_sim = '1' and

            a_buffer_enable_sim = '0' and
            cache_1_enable_sim = '0' and
            cache_2_enable_sim = '0',
            "s in buf b (LSB)"
        );

        current_route := current_route + 1;
        routing_selection_sim <= std_logic_vector(to_unsigned(current_route, 4));

        wait for 1 us;
        test(
            b_buffer_sim = "0010" and
            b_buffer_enable_sim = '1' and

            a_buffer_enable_sim = '0' and
            cache_1_enable_sim = '0' and
            cache_2_enable_sim = '0',
            "s in buf b (MSB)"
        );

        current_route := current_route + 1;
        routing_selection_sim <= std_logic_vector(to_unsigned(current_route, 4));

        wait for 1 us;
        test(
            cache_1_emmited_sim = "00100111" and
            cache_1_enable_sim = '1' and

            a_buffer_enable_sim = '0' and
            b_buffer_enable_sim = '0' and
            cache_2_enable_sim = '0',
            "s in cache 1"
        );

        current_route := current_route + 1;
        routing_selection_sim <= std_logic_vector(to_unsigned(current_route, 4));

        wait for 1 us;
        test(
            cache_2_emmited_sim = "00100111" and
            cache_2_enable_sim = '1' and

            a_buffer_enable_sim = '0' and
            b_buffer_enable_sim = '0' and
            cache_1_enable_sim = '0',
            "s in cache 2"
        );

        current_route := current_route + 1;
        routing_selection_sim <= std_logic_vector(to_unsigned(current_route, 4));
        
        wait for 1 us;
        test(
            a_buffer_sim = "0101" and
            a_buffer_enable_sim = '1' and

            b_buffer_enable_sim = '0' and
            cache_1_enable_sim = '0' and
            cache_2_enable_sim = '0',
            "cache 1 in buf a (LSB)"
        );

        current_route := current_route + 1;
        routing_selection_sim <= std_logic_vector(to_unsigned(current_route, 4));

        wait for 1 us;
        test(
            a_buffer_sim = "1000" and
            a_buffer_enable_sim = '1' and

            b_buffer_enable_sim = '0' and
            cache_1_enable_sim = '0' and
            cache_2_enable_sim = '0',
            "cache 1 in buf a (MSB)"
        );

        current_route := current_route + 1;
        routing_selection_sim <= std_logic_vector(to_unsigned(current_route, 4));

        wait for 1 us;
        test(
            b_buffer_sim = "0101" and
            b_buffer_enable_sim = '1' and

            a_buffer_enable_sim = '0' and
            cache_1_enable_sim = '0' and
            cache_2_enable_sim = '0',
            "cache 1 in buf b (LSB)"
        );

        current_route := current_route + 1;
        routing_selection_sim <= std_logic_vector(to_unsigned(current_route, 4));

        wait for 1 us;
        test(
            b_buffer_sim = "1000" and
            b_buffer_enable_sim = '1' and

            a_buffer_enable_sim = '0' and
            cache_1_enable_sim = '0' and
            cache_2_enable_sim = '0',
            "cache 1 in buf b (MSB)"
        );

        current_route := current_route + 1;
        routing_selection_sim <= std_logic_vector(to_unsigned(current_route, 4));
        
        wait for 1 us;
        test(
            a_buffer_sim = "0110" and
            a_buffer_enable_sim = '1' and

            b_buffer_enable_sim = '0' and
            cache_1_enable_sim = '0' and
            cache_2_enable_sim = '0',
            "cache 2 in buf a (LSB)"
        );

        current_route := current_route + 1;
        routing_selection_sim <= std_logic_vector(to_unsigned(current_route, 4));

        wait for 1 us;
        test(
            a_buffer_sim = "0100" and
            a_buffer_enable_sim = '1' and

            b_buffer_enable_sim = '0' and
            cache_1_enable_sim = '0' and
            cache_2_enable_sim = '0',
            "cache 2 in buf a (MSB)"
        );

        current_route := current_route + 1;
        routing_selection_sim <= std_logic_vector(to_unsigned(current_route, 4));

        wait for 1 us;
        test(
            b_buffer_sim = "0110" and
            b_buffer_enable_sim = '1' and

            a_buffer_enable_sim = '0' and
            cache_1_enable_sim = '0' and
            cache_2_enable_sim = '0',
            "cache 2 in buf b (LSB)"
        );

        current_route := current_route + 1;
        routing_selection_sim <= std_logic_vector(to_unsigned(current_route, 4));

        wait for 1 us;
        test(
            b_buffer_sim = "0100" and
            b_buffer_enable_sim = '1' and

            a_buffer_enable_sim = '0' and
            cache_1_enable_sim = '0' and
            cache_2_enable_sim = '0',
            "cache 2 in buf b (MSB)"
        );

        wait;
    end process;


end architecture;
