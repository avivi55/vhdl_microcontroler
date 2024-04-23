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
    type t_matrix is array (0 to 127) of std_logic_vector (9 downto 0);
    signal instruction_pointer : integer := 0;
    constant matrix : t_matrix := (
        "1101100001",
        "1101100010",
        others => "0000000000"
    );
begin

    process(clock)
    begin
        function_selection <= matrix(instruction_pointer)(9 downto 6);
        route_selection <= matrix(instruction_pointer)(5 downto 2);
        output_selection <= matrix(instruction_pointer)(1 downto 0);

        if rising_edge(clock) then
            instruction_pointer <= instruction_pointer + 1 when instruction_pointer < 127 else 0;
        end if;
        -- if rising_edge(clock) then
        --     instruction_pointer <= adress when adress < 127 else 0;
        -- end if;
    end process;

end architecture;