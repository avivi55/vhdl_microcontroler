library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

entity dbus_route_test is

end entity;

architecture dbus_route_test_arch of dbus_route_test is

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


    constant PERIOD : time := 100 us;
    signal clock_sim : std_logic := '0';
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

    test_buf : nbuffer
    port map (
    	e1 => cache_1_emmited_sim,
        reset => '0',
        enable => cache_1_enable_sim,
        clock => clock_sim,
        s1 => cache_1_received_sim
    );


    clk : process
    begin
    	clock_sim <= '0';
        wait for 0.5*PERIOD;
        clock_sim <= '1';
        wait for 0.5*PERIOD;
         if now = 16*PERIOD then
        	wait;
        end if;

    end process;


    proc : process	
    begin

        a_in_sim <= "0001";
        b_in_sim <= "0010";
        alu_output_sim <= "01000011";

        for route in 0 to 7 loop
            routing_selection_sim <= std_logic_vector(to_unsigned(route, 4));
            wait for 100 us;
        end loop;

        -- cache_1_received_sim <= "10000111";
        cache_2_received_sim <= "01011010";

        for route in 8 to 15 loop
            routing_selection_sim <= std_logic_vector(to_unsigned(route, 4));
            wait for 100 us;
        end loop;
        wait;        
    end process;

end architecture;
