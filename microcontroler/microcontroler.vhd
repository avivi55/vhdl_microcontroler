library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;


entity microcontroler is
    port (
        clock : in std_logic;
        reset : in std_logic;
        
        a_in : in std_logic_vector (3 downto 0);
        b_in : in std_logic_vector (3 downto 0);
        carries_received : in std_logic_vector (1 downto 0);
        
        final_output : out std_logic_vector (7 downto 0);
        carries_emitted : out std_logic_vector (1 downto 0)
    );
end entity;


architecture microcontroler_arch of microcontroler is

    component nbuffer is
        generic (N : integer := 4);
        port (
            e1 : in std_logic_vector (N-1 downto 0);
            reset : in std_logic;
            enable : in std_logic;
            clock : in std_logic;
            s1 : out std_logic_vector (N-1 downto 0)
        );
    end component;

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

    component instructions is
        port (
            clock : in std_logic;
            program_choice : in std_logic_vector (1 downto 0);
            function_selection : out std_logic_vector (3 downto 0);
            route_selection : out std_logic_vector (3 downto 0);
            output_selection : out std_logic_vector (1 downto 0)
        );
    end component;

    component dbus is
        port (
            cache_1_received : in std_logic_vector (7 downto 0); -- from buffer
            cache_1_emitted : out std_logic_vector (7 downto 0);
            cache_1_enable : out std_logic;
            cache_2_received : in std_logic_vector (7 downto 0); -- from buffer
            cache_2_emitted : out std_logic_vector (7 downto 0);
            cache_2_enable : out std_logic;
            outputing_selection : in std_logic_vector (1 downto 0); -- from buffer
            routing_selection : in std_logic_vector (3 downto 0); 
            alu_output : in std_logic_vector (7 downto 0);
            a_buffer_enable : out std_logic;
            a_buffer : out std_logic_vector (3 downto 0);
            b_buffer_enable : out std_logic;
            b_buffer : out std_logic_vector (3 downto 0);
            a_in : in std_logic_vector (3 downto 0);
            b_in : in std_logic_vector (3 downto 0);
            final_output : out std_logic_vector (7 downto 0)
        );
    end component;


    signal 
    cache_1_enable_sim, 
    cache_2_enable_sim, 
    a_buffer_enable_sim, 
    b_buffer_enable_sim : std_logic := '0';
    
    signal 
    output_selection_sim,
    carries_received_sim,
    outputing_selection_sim,
    carries_emitted_sim : std_logic_vector (1 downto 0) := (others => '0');
    
    signal 
    function_selection_sim,
    route_selection_sim,
    b_buffer_sim,
    a_buffer_sim,
    a_sim, 
    b_sim, 
    functioning_selection_sim : std_logic_vector (3 downto 0) := (others => '0');
    
    signal 
    cache_1_emitted_sim, 
    cache_1_received_sim,
    cache_2_received_sim,
    cache_2_emitted_sim, 
    alu_output_sim : std_logic_vector (7 downto 0) := (others => '0');

begin

    intructions : instructions
    port map (
        clock => clock,
        function_selection => function_selection_sim,
        program_choice => "11",
        route_selection => route_selection_sim,
        output_selection => output_selection_sim
    );

    out_sel_buf : nbuffer
    generic map(n => 2)
    port map (
        clock => clock,
        reset => reset,
        enable => '1',
        e1 => output_selection_sim,
        s1 => outputing_selection_sim
    );

    fn_sel_buf : nbuffer
    generic map(n => 4)
    port map (
        clock => clock,
        reset => reset,
        enable => '1',
        e1 => function_selection_sim,
        s1 => functioning_selection_sim
    );

    alu_comp : alu
    port map(
        a => a_sim,
        b => b_sim,
        function_selection => functioning_selection_sim,
        carries_received => carries_received_sim,
        carries_emitted => carries_emitted_sim,
        alu_output  => alu_output_sim
    );

    carries_buf : nbuffer
    generic map(n => 2)
    port map (
        clock => clock,
        reset => reset,
        enable => '1',
        e1 => carries_received,
        s1 => carries_received_sim
    );

    a_buf : nbuffer
    generic map(n => 4)
    port map (
        clock => clock,
        reset => reset,
        enable => a_buffer_enable_sim,
        e1 => a_buffer_sim,
        s1 => a_sim
    );
    
    b_buf : nbuffer
    generic map(n => 4)
    port map (
        clock => clock,
        reset => reset,
        enable => b_buffer_enable_sim,
        e1 => b_buffer_sim,
        s1 => b_sim
    );

    dbus_comp : dbus
    port map (
        cache_1_received => cache_1_received_sim,
        cache_1_emitted => cache_1_emitted_sim,
        cache_1_enable => cache_1_enable_sim,
        cache_2_received => cache_2_received_sim,
        cache_2_emitted => cache_2_emitted_sim,
        cache_2_enable => cache_2_enable_sim,
        outputing_selection => outputing_selection_sim,
        routing_selection => route_selection_sim,
        alu_output => alu_output_sim,
        a_buffer_enable => a_buffer_enable_sim,
        a_buffer => a_buffer_sim,
        b_buffer_enable => b_buffer_enable_sim,
        b_buffer => b_buffer_sim,
        a_in => a_in,
        b_in => b_in,
        final_output => final_output
    );

    cache1_buf : nbuffer
    generic map(n => 8)
    port map (
        clock => clock,
        reset => reset,
        enable => cache_1_enable_sim,
        e1 => cache_1_emitted_sim,
        s1 => cache_1_received_sim
    );

    cache2_buf : nbuffer
    generic map(n => 8)
    port map (
        clock => clock,
        reset => reset,
        enable => cache_2_enable_sim,
        e1 => cache_2_emitted_sim,
        s1 => cache_2_received_sim
    );

end architecture;