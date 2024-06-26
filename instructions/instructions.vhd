library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity instructions is
    port (
        clock : in std_logic;
        program_choice : in std_logic_vector (1 downto 0);
        function_selection : out std_logic_vector (3 downto 0);
        route_selection : out std_logic_vector (3 downto 0);
        output_selection : out std_logic_vector (1 downto 0)
    );
end entity;

architecture instructions_arch of instructions is
    
    -- Concatenates three std_logic_vectors to separate the 3 different selections in the binary instruction
    function to_instr(fcn : std_logic_vector; route : std_logic_vector; outpt : std_logic_vector) return std_logic_vector is
    begin
        return fcn & route & outpt;
    end function;

    signal instruction_pointer : integer := 0;

    type t_matrix is array (0 to 127) of std_logic_vector (9 downto 0);
    type l_matrix is array (0 to 2) of t_matrix;

    constant a_times_b : t_matrix := (
        -----------------------------------a * b--------------------------------------------
        to_instr("0000", "0000", "00"), -- nop, a -> buf a, nop
        to_instr("0000", "0001", "00"), -- nop, b -> buf b, nop
        to_instr("1111", "0110", "00"), -- a*b, s -> cache1, nop
        to_instr("0000", "0110", "01"), -- nop, s -> cache1, resout -> cache1,
        ------------------------------------------------------------------------------------
        others => "0000000001"
    );

    constant a_plus_b_xnor_a : t_matrix := (
        -----------------------not ((a + b) xor a)------------------------------------------
        to_instr("0000", "0000", "00"), -- a in buf a
        to_instr("0000", "0001", "00"), -- b in buf b

        to_instr("1101", "0110", "00"), -- a+b, s -> cache1, nop,
        to_instr("0000", "0110", "00"), -- nop, s -> cache1, nop,  to make sure it is in cache1

        to_instr("0000", "1010", "00"),-- nop, cache1(lsb) in buf b, nop

        to_instr("1011", "0111", "00"),-- a xor b, s(lsb) -> cache2, nop
        to_instr("0000", "0111", "00"),-- nop, s(lsb) -> cache2, nop

        to_instr("0000", "1100", "00"),-- nop , cache2(lsb) -> bufa, nop
        to_instr("0111", "0110", "11"),-- not bufa, s -> cache1, s-> resout
        to_instr("0000", "0110", "01"),-- not bufa, s -> cache1, s-> resout
        ------------------------------------------------------------------------------------
        
        others => "0000000001"
    );

    constant a0_and_b1_or_a1_and_b0 : t_matrix := (
        ----------------------(a(0) and b(1)) or (b(0) and a(1))-----------------------------
        -------isolating a(0)-------
        to_instr("0000", "0000", "00"), -- nop, a in buf a, nop

        to_instr("0010", "0110", "00"), -- buf a << 1, pseudo nop (s-> c1), nop
        to_instr("0000", "0010", "00"), -- nop, s-> buf a, nop

        to_instr("0010", "0110", "00"), -- buf a << 1, pseudo nop (s-> c1), nop
        to_instr("0000", "0010", "00"), -- nop, s-> buf a, nop
        
        to_instr("0010", "0110", "00"), -- buf a << 1, pseudo nop (s-> c1), nop
        to_instr("0000", "0010", "00"), -- nop, s-> buf a, nop

        to_instr("0001", "0110", "00"), -- 1 >> buf a, pseudo nop (s-> c1), nop
        to_instr("0000", "0010", "00"), -- nop, s-> buf a, nop
        
        to_instr("0001", "0110", "00"), -- 1 >> buf a, pseudo nop (s-> c1), nop
        to_instr("0000", "0010", "00"), -- nop, s-> buf a, nop

        to_instr("0001", "0110", "00"), -- 1 >> buf a, pseudo nop (s-> c1), nop
        to_instr("0000", "0010", "00"), -- nop, s-> buf a, nop
        ----------------------------

        -------isolating b(1)-------
        to_instr("0000", "0001", "00"), -- nop, b in buf b, nop

        to_instr("0100", "0111", "00"), -- buf b << 1, pseudo nop (s-> c2), nop
        to_instr("0000", "0100", "00"), -- nop, s -> buf b, nop

        to_instr("0100", "0111", "00"), -- buf b << 1, pseudo nop (s-> c2), nop
        to_instr("0000", "0100", "00"), -- nop, s -> buf b, nop

        to_instr("0011", "0111", "00"), -- 1 >> buf b, pseudo nop (s-> c2), nop
        to_instr("0000", "0100", "00"), -- nop, s -> buf b, nop

        to_instr("0011", "0111", "00"), -- 1 >> buf b, pseudo nop (s-> c2), nop
        to_instr("0000", "0100", "00"), -- nop, s -> buf b, nop

        to_instr("0011", "0111", "00"), -- 1 >> buf b, pseudo nop (s-> c2), nop
        to_instr("0000", "0100", "00"), -- nop, s -> buf b, nop
        ----------------------------

        --------------computing a(0) and b(1)--------------
        to_instr("1001", "0110", "00"), -- a and b, s -> cache1, nop
        to_instr("0000", "0110", "00"), -- nop, s -> cache1, nop
        ----------------------------

        -------isolating a(1)-------
        to_instr("0000", "0000", "00"), -- nop, a in buf a, nop

        to_instr("0010", "0111", "00"), -- buf a << 1, s-> buf a, nop
        to_instr("0000", "0010", "00"), -- nop, s-> buf a, nop
        
        to_instr("0010", "0111", "00"), -- buf a << 1, s-> buf a, nop
        to_instr("0000", "0010", "00"), -- nop, s-> buf a, nop
        
        to_instr("0001", "0111", "00"), -- 1 >> buf a, pseudo nop (s-> c1), nop
        to_instr("0000", "0010", "00"), -- nop, s-> buf a, nop
        
        to_instr("0001", "0111", "00"), -- 1 >> buf a, pseudo nop (s-> c1), nop
        to_instr("0000", "0010", "00"), -- nop, s-> buf a, nop

        to_instr("0001", "0111", "00"), -- 1 >> buf a, pseudo nop (s-> c1), nop
        to_instr("0000", "0010", "00"), -- nop, s-> buf a, nop
        ----------------------------

        -------isolating b(0)-------
        to_instr("0000", "0001", "00"), -- nop, b in buf b, nop

        to_instr("0100", "0111", "00"), -- buf b << 1, pseudo nop (s-> c2), nop
        to_instr("0000", "0100", "00"), -- nop, s -> buf b, nop

        to_instr("0100", "0111", "00"), -- buf b << 1, pseudo nop (s-> c2), nop
        to_instr("0000", "0100", "00"), -- nop, s -> buf b, nop

        to_instr("0100", "0111", "00"), -- buf b << 1, pseudo nop (s-> c2), nop
        to_instr("0000", "0100", "00"), -- nop, s -> buf b, nop

        to_instr("0011", "0111", "00"), -- 1 >> buf b, pseudo nop (s-> c2), nop
        to_instr("0000", "0100", "00"), -- nop, s -> buf b, nop

        to_instr("0011", "0111", "00"), -- 1 >> buf b, pseudo nop (s-> c2), nop
        to_instr("0000", "0100", "00"), -- nop, s -> buf b, nop

        to_instr("0011", "0111", "00"), -- 1 >> buf b, pseudo nop (s-> c2), nop
        to_instr("0000", "0100", "00"), -- nop, s -> buf b, nop
        ----------------------------


        ---computing a(1) and b(0)---
        to_instr("1001", "0111", "00"), -- a and b, s -> cache2, nop
        to_instr("0000", "0111", "00"), -- nop, s -> cache2, nop
        ----------------------------

        ---computing final result---
        to_instr("0000", "1000", "00"), -- nop, cache1 -> a, nop
        to_instr("0000", "1110", "00"), -- nop, cache2 -> b, nop
        to_instr("1010", "0111", "11"), -- a or b, s -> cache2, s -> cache2
        to_instr("0000", "0111", "10"), -- nop, s -> cache2, s -> cache2
        ----------------------------
        ------------------------------------------------------------------------------------

        others => "0000000010"
    );

    constant programs : l_matrix := (
        a_times_b,
        a_plus_b_xnor_a,
        a0_and_b1_or_a1_and_b0
    );

begin
    proc : process(clock)
        variable current_program : integer := 0;
        variable previous_program_choice : std_logic_vector(1 downto 0) := "00";
    begin
        current_program := to_integer(unsigned(program_choice)) rem 3;

        function_selection <= programs(current_program)(instruction_pointer)(9 downto 6);
        route_selection <= programs(current_program)(instruction_pointer)(5 downto 2);
        output_selection <= programs(current_program)(instruction_pointer)(1 downto 0);

        if rising_edge(clock) then -- the output is on falling edge
            instruction_pointer <= instruction_pointer + 1 when instruction_pointer < 127 else 0;

            if program_choice /= previous_program_choice then
                instruction_pointer <= 0;
                previous_program_choice := program_choice;
            end if;
        end if;
    end process;

end architecture;