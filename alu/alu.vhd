library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity alu is
    port (
        a : in std_logic_vector (3 downto 0);
        b : in std_logic_vector (3 downto 0);
        function_selection : in std_logic_vector (3 downto 0);
        carries_received : in std_logic_vector (1 downto 0);
        carries_emitted : out std_logic_vector (1 downto 0);
        alu_output : out std_logic_vector (7 downto 0)
    );
end entity;

architecture alu_arch of alu is
    type instruction is (nop, rs_a, rs_b, ls_a, ls_b, id_a, id_b, n_a, n_b, a_and_b, a_or_b, a_xor_b, add, add_c, sub, mul);
    signal current_function: instruction := nop;
begin

    process(a, b, function_selection, carries_received)
        variable bigger_a, bigger_b: std_logic_vector(7 downto 0);
        
        variable left_carry_received, right_carry_received, left_carry_emmited, right_carry_emmited: std_logic;
    begin
        bigger_a(7 downto 4) := (others => a(3));
        bigger_a(3 downto 0) := a;

        bigger_b(7 downto 4) := (others => b(3));
        bigger_b(3 downto 0) := b;

        left_carry_received := carries_received(1);
        right_carry_received := carries_received(0);

        left_carry_emmited := '0';
        right_carry_emmited := '0';

        case function_selection is
            when "0001" =>
                right_carry_emmited := a(0);
                alu_output(2 downto 0) <= a(3 downto 1);
                alu_output(3) <= left_carry_received;
                alu_output(7 downto 4) <= (others => '0');
                
                current_function <= rs_a;
            when "0010" => -- sur 4b
                left_carry_emmited := a(3);
                alu_output(3 downto 1) <= a(2 downto 0);
                alu_output(0) <= right_carry_received;
                alu_output(7 downto 4) <= (others => '0');

                current_function <= ls_a;
            when "0011" =>
                right_carry_emmited := b(0);
                alu_output(2 downto 0) <= b(3 downto 1);
                alu_output(3) <= left_carry_received;
                alu_output(7 downto 4) <= (others => '0');

                current_function <= rs_b;
            when "0100" => -- sur 4b
                left_carry_emmited := b(3);
                alu_output(3 downto 1) <= b(2 downto 0);
                alu_output(0) <= right_carry_received;
                alu_output(7 downto 4) <= (others => '0');

                current_function <= ls_b;
            when "0101" =>
                alu_output <= bigger_a;

                current_function <= id_a;
            when "0110" =>
                alu_output <= bigger_b;

                current_function <= id_b;
            when "0111" =>
                alu_output <= "0000" & not a;

                current_function <= n_a;
            when "1000" =>
                alu_output <= "0000" & not b;

                current_function <= n_b;
            when "1001" =>
                alu_output <= "0000" & (a and b);

                current_function <= a_and_b;
            when "1010" =>
                alu_output <= "0000" & (a or b);

                current_function <= a_or_b;
            when "1011" =>
                alu_output <= "0000" & (a xor b);

                current_function <= a_xor_b;
            when "1100" =>
                alu_output <= bigger_a + bigger_b + carries_received(0);

                current_function <= add_c;
            when "1101" =>
                alu_output <= bigger_a + bigger_b;

                current_function <= add;
            when "1110" =>
                alu_output <= bigger_a - bigger_b;

                current_function <= sub;
            when "1111" =>
                alu_output <= a * b;

                current_function <= mul;
            when others =>
                alu_output <= (others => '0');

                current_function <= nop;
        end case;
        
        carries_emitted <= left_carry_emmited & right_carry_emmited;
    end process;

end architecture;