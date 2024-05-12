library ieee;
use ieee.std_logic_1164.all;

entity nbuffer is
    generic (
        n : integer := 4
    );
    port (
        e1 : in std_logic_vector (n-1 downto 0);
        reset : in std_logic;
        enable : in std_logic;
        clock : in std_logic;
        s1 : out std_logic_vector (n-1 downto 0)
    );
end entity;

architecture nbuffer_arch of nbuffer is
begin

    process (clock, reset)
    begin

        if reset = '1' then
            s1 <= (others => '0');
        elsif rising_edge(clock) then
            if enable = '1' then
                s1 <= e1;
            end if;
        end if;

    end process;

end architecture;

