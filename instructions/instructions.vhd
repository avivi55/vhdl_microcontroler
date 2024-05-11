library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

entity instructions_buf is
    port (
        clock : in std_logic;
        -- adress : in std_logic;

        function_selection : out std_logic_vector (3 downto 0);
        route_selection : out std_logic_vector (3 downto 0);
        output_selection : out std_logic_vector (1 downto 0)
    );
end entity;



architecture instructions_buf_arch of instructions_buf is
    
    function to_instr(fcn : std_logic_vector; route : std_logic_vector; outpt : std_logic_vector) return std_logic_vector is
    begin
        return fcn & route & outpt;
    end function;

    type t_matrix is array (0 to 127) of std_logic_vector (9 downto 0);
    signal instruction_pointer : integer := 0;
    constant matrix : t_matrix := (

        -----------------------------------a * b--------------------------------------------
        to_instr("0000", "0000", "00"), -- a in buf a
        to_instr("0000", "0001", "00"), -- b in buf b 
        to_instr("1111", "0110", "00"), -- a*b, s -> cache1, nop,
        to_instr("0000", "0110", "01"), -- nop, s -> cache1, resout -> cache1,
        ------------------------------------------------------------------------------------

        
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
        ------------------------------------------------------------------------------------


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

        to_instr("0100", "0000", "00"), -- buf b << 1, pseudo nop (s-> c2), nop
        to_instr("0000", "0100", "00"), -- nop, s -> buf b, nop

        to_instr("0100", "0000", "00"), -- buf b << 1, pseudo nop (s-> c2), nop
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

        to_instr("0010", "0010", "00"), -- buf a << 1, s-> buf a, nop
        to_instr("0000", "0010", "00"), -- nop, s-> buf a, nop
        
        to_instr("0010", "0010", "00"), -- buf a << 1, s-> buf a, nop
        to_instr("0000", "0010", "00"), -- nop, s-> buf a, nop
        
        to_instr("0001", "0110", "00"), -- 1 >> buf a, pseudo nop (s-> c1), nop
        to_instr("0000", "0010", "00"), -- nop, s-> buf a, nop
        
        to_instr("0001", "0110", "00"), -- 1 >> buf a, pseudo nop (s-> c1), nop
        to_instr("0000", "0010", "00"), -- nop, s-> buf a, nop

        to_instr("0001", "0110", "00"), -- 1 >> buf a, pseudo nop (s-> c1), nop
        to_instr("0000", "0010", "00"), -- nop, s-> buf a, nop
        ----------------------------

        -------isolating b(0)-------
        to_instr("0000", "0001", "00"), -- nop, b in buf b, nop

        to_instr("0100", "0000", "00"), -- buf b << 1, pseudo nop (s-> c2), nop
        to_instr("0000", "0100", "00"), -- nop, s -> buf b, nop

        to_instr("0100", "0000", "00"), -- buf b << 1, pseudo nop (s-> c2), nop
        to_instr("0000", "0100", "00"), -- nop, s -> buf b, nop

        to_instr("0100", "0000", "00"), -- buf b << 1, pseudo nop (s-> c2), nop
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
        to_instr("1010", "1110", "11"), -- a or b, pseudo nop(a -> buf a), s -> resout
        ----------------------------
        ------------------------------------------------------------------------------------

        others => "0000000000"
    );
begin

    process(clock)
    begin
        function_selection <= matrix(instruction_pointer)(9 downto 6);
        route_selection <= matrix(instruction_pointer)(5 downto 2);
        output_selection <= matrix(instruction_pointer)(1 downto 0);

        if rising_edge(clock) then -- the output is on falling edge
            instruction_pointer <= instruction_pointer + 1 when instruction_pointer < 127 else 0;
        end if;
    end process;

end architecture;