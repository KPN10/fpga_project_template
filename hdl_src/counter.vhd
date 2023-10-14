library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.STD_LOGIC_UNSIGNED.ALL;

entity counter is
    Port (
        rst,clk:in std_logic;
        o: out std_logic
    );
end counter;

architecture count_arch of counter is
    signal counter:std_logic_vector(26 downto 0);
    begin
        process(rst,clk)
        begin
            if (rst = '1') then counter <= (others=>'0');
            elsif (rising_edge(clk)) then
                counter <= counter + 1;
            end if;
        end process;
        o <= counter(26);
    end architecture;
