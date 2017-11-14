library ieee;
use ieee.std_logic_1164.all;

use work.ultra_data_types.all;
use work.ultra_constants.all;

entity ultra_null_algo is
    port (
       clk : in std_logic;
       rst : in std_logic;
       d   : in ndata(4*N_QUADS-1 downto 0);
       q   : out ndata(4*N_QUADS-1 downto 0)
    );
end ultra_null_algo;

architecture behavioral of ultra_null_algo is
    signal buff: ndata(4*N_QUADS-1 downto 0);
begin
    ciao: process(clk,rst)
    begin
        if rst = '1' then
            for i in 4*N_QUADS-1 downto 0 loop
                buff(i).valid <= '0';
            end loop;
        elsif rising_edge(clk) then
            for i in 4*N_QUADS-1 downto 0 loop
                buff(i).data  <= d(i).data;
                buff(i).valid <= d(i).valid;
                q(i).data  <= buff(i).data;
                q(i).valid <= buff(i).valid;
            end loop;
        end if;
    end process;
end behavioral;
