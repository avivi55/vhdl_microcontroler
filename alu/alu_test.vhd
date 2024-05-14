library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity alu_test is
end entity;

architecture alu_test_arch of alu_test is

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

    signal a_sim, b_sim, sel_fct_sim : std_logic_vector (3 downto 0) := (others => '0');
    signal sr_in_sim : std_logic_vector (1 downto 0) := (others => '0');
    signal sr_out_sim : std_logic_vector (1 downto 0);
    signal s_sim : std_logic_vector (7 downto 0);

    procedure test(test: boolean; name: string) is
    begin
        if test then 
            report name & ": test passed.";
        else 
            report name & ": test failed !"  severity error;
        end if;        
    end procedure;
    
begin

    test_component : alu
    port map ( 
    	a => a_sim,
        b => b_sim,
        function_selection => sel_fct_sim,
        carries_received => sr_in_sim,
        carries_emitted => sr_out_sim,
        alu_output => s_sim
    );

    tests : process
        variable current_function: integer := 0;
    begin

        a_sim <= "0010";
        b_sim <= "1001";

        wait for 1 us;
        test(s_sim = "00000000" and sr_out_sim = "00", "nop");

        current_function := current_function + 1;
        sel_fct_sim <= std_logic_vector(to_unsigned(current_function, 4));


        wait for 1 us;
        test(s_sim = "00000001" and sr_out_sim = "00", "right shift A no carry");
        
        sr_in_sim <= "10";
        wait for 1 us;
        test(s_sim = "00001001" and sr_out_sim = "00", "right shift A with carry");
        sr_in_sim <= "00";

        current_function := current_function + 1;
        sel_fct_sim <= std_logic_vector(to_unsigned(current_function, 4));

        
        wait for 1 us;
        test(s_sim = "00000100" and sr_out_sim = "00", "left shift A no carry");

        sr_in_sim <= "01";
        wait for 1 us;
        test(s_sim = "00000101" and sr_out_sim = "00", "right shift A with carry");
        sr_in_sim <= "00";

        current_function := current_function + 1;
        sel_fct_sim <= std_logic_vector(to_unsigned(current_function, 4));

        
        wait for 1 us;
        test(s_sim = "0000100" and sr_out_sim = "01", "right shift B no carry");

        sr_in_sim <= "10";
        wait for 1 us;
        test(s_sim = "00001100" and sr_out_sim = "01", "right shift B with carry");
        sr_in_sim <= "00";

        current_function := current_function + 1;
        sel_fct_sim <= std_logic_vector(to_unsigned(current_function, 4));

        wait for 1 us;
        test(s_sim = "00000010" and sr_out_sim = "10", "left shift B no carry");

        sr_in_sim <= "01";
        wait for 1 us;
        test(s_sim = "00000011" and sr_out_sim = "10", "right shift B with carry");
        sr_in_sim <= "00";

        current_function := current_function + 1;
        sel_fct_sim <= std_logic_vector(to_unsigned(current_function, 4));

        wait for 1 us;
        test(s_sim = "00000010" and sr_out_sim = "00", "A identity");

        current_function := current_function + 1;
        sel_fct_sim <= std_logic_vector(to_unsigned(current_function, 4));
        
        wait for 1 us;
        test(s_sim = "11111001" and sr_out_sim = "00", "B identity");

        current_function := current_function + 1;
        sel_fct_sim <= std_logic_vector(to_unsigned(current_function, 4));

        wait for 1 us;
        test(s_sim = "00001101" and sr_out_sim = "00", "not a");

        current_function := current_function + 1;
        sel_fct_sim <= std_logic_vector(to_unsigned(current_function, 4));

        wait for 1 us;
        test(s_sim = "00000110" and sr_out_sim = "00", "not b");

        current_function := current_function + 1;
        sel_fct_sim <= std_logic_vector(to_unsigned(current_function, 4));

        wait for 1 us;
        test(s_sim = "00000000" and sr_out_sim = "00", "a and b");

        current_function := current_function + 1;
        sel_fct_sim <= std_logic_vector(to_unsigned(current_function, 4));

        wait for 1 us;
        test(s_sim = "00001011" and sr_out_sim = "00", "a or b");

        current_function := current_function + 1;
        sel_fct_sim <= std_logic_vector(to_unsigned(current_function, 4));

        wait for 1 us;
        test(s_sim = "00001011" and sr_out_sim = "00", "a xor b");

        current_function := current_function + 1;
        sel_fct_sim <= std_logic_vector(to_unsigned(current_function, 4));

        sr_in_sim <= "01";
        wait for 1 us;
        test(s_sim = "11111100" and sr_out_sim = "00", "a + b with carry");
        sr_in_sim <= "00";

        current_function := current_function + 1;
        sel_fct_sim <= std_logic_vector(to_unsigned(current_function, 4));
 
        wait for 1 us;
        test(s_sim = "11111011" and sr_out_sim = "00", "a + b no carry");

        current_function := current_function + 1;
        sel_fct_sim <= std_logic_vector(to_unsigned(current_function, 4));

        wait for 1 us;
        test(s_sim = "00001001" and sr_out_sim = "00", "a - b");

        current_function := current_function + 1;
        sel_fct_sim <= std_logic_vector(to_unsigned(current_function, 4));
        
        wait for 1 us;
        test(s_sim = "11110010" and sr_out_sim = "00", "a * b");
        
        wait;      
    end process;

end architecture;
