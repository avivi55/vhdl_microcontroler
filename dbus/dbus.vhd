library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity dbus is
    port (
        -- Caches
        cache_1_received : in std_logic_vector (7 downto 0); -- from buffer
        cache_1_emmited : out std_logic_vector (7 downto 0);
        cache_1_enable : out std_logic;
        
        cache_2_received : in std_logic_vector (7 downto 0); -- from buffer
        cache_2_emmited : out std_logic_vector (7 downto 0);
        cache_2_enable : out std_logic;

        -- Selections
        output_selection : in std_logic_vector (1 downto 0); -- from buffer
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
end entity;

architecture dbus_arch of dbus is

    type route is (
        a_in_buffa,
        b_in_buffb,
        alu_in_buffa_lsb,
        alu_in_buffa_msb, 
        alu_in_buffb_lsb, 
        alu_in_buffb_msb, 
        alu_in_cache1, 
        alu_in_cache2,
        cache1_in_buffa_lsb,
        cache1_in_buffa_msb,
        cache1_in_buffb_lsb,
        cache1_in_buffb_msb,
        cache2_in_buffa_lsb,
        cache2_in_buffa_msb,
        cache2_in_buffb_lsb,
        cache2_in_buffb_msb
    );

    type output_route is (no_output, cache1, cache2, alu);

    signal current_output: output_route := no_output;
    signal current_route: route := a_in_buffa;

begin
    output_selector: process(output_selection, a_in, b_in)

    begin
        case output_selection is
            when "01" =>
                final_output <= cache_1_received;
                current_output <= cache1;

            when "10" =>
                final_output <= cache_2_received;
                current_output <= cache2;

            when "11" =>
                final_output <= alu_output;
                current_output <= alu;

            when others =>
                final_output <= (others => '0');
                current_output <= no_output;

        end case;
    end process;
    
    route_selector: process(routing_selection, a_in, b_in)

    begin
        a_buffer_enable <= '0';
        b_buffer_enable <= '0';

        case routing_selection is
            when "0001" =>
                b_buffer <= b_in;
                b_buffer_enable <= '0';
                current_route <= b_in_buffb;
            
            when "0010" =>
                a_buffer <= alu_output(3 downto 0);
                a_buffer_enable <= '0';
                current_route <= alu_in_buffa_lsb;
            
            when "0011" =>
                a_buffer <= alu_output(7 downto 4);
                a_buffer_enable <= '0';
                current_route <= alu_in_buffa_msb;
            
            when "0100" =>
                b_buffer <= alu_output(3 downto 0);
                b_buffer_enable <= '0';
                current_route <= alu_in_buffb_lsb;
            
            when "0101" =>
                b_buffer <= alu_output(7 downto 4);
                b_buffer_enable <= '0';
                current_route <= alu_in_buffb_msb;
            
            when "0110" =>
                cache_1_emmited <= alu_output;
                current_route <= alu_in_cache1;
            
            when "0111" =>
                cache_2_emmited <= alu_output;
                current_route <= alu_in_cache2;
            
            when "1000" =>
                a_buffer <= cache_1_received(3 downto 0);
                current_route <= cache1_in_buffa_lsb;
            
            when "1001" =>
                a_buffer <= cache_1_received(7 downto 4);
                current_route <= cache1_in_buffa_msb;
            
            when "1010" =>
                b_buffer <= cache_1_received(3 downto 0);
                current_route <= cache1_in_buffb_lsb;
            
            when "1011" =>
                b_buffer <= cache_1_received(7 downto 4);
                current_route <= cache1_in_buffb_msb;
            
            when "1100" =>
                a_buffer <= cache_2_received(3 downto 0);
                current_route <= cache2_in_buffa_lsb;
            
            when "1101" =>
                a_buffer <= cache_2_received(7 downto 4);
                current_route <= cache2_in_buffa_msb;
            
            when "1110" =>
                b_buffer <= cache_2_received(3 downto 0);
                current_route <= cache2_in_buffb_lsb;
            
            when "1111" =>
                b_buffer <= cache_2_received(7 downto 4);
                current_route <= cache2_in_buffb_msb;

            when others =>
                a_buffer <= a_in;
                a_buffer_enable <= '0';

                current_route <= a_in_buffa;
        end case;
    end process;
end architecture;