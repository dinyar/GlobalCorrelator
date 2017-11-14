library std;
use std.env.all;
library ieee;
use ieee.std_logic_1164.all;

entity testbench is
--  Port ( );
end testbench;

architecture Behavioral of testbench is
    signal clk_p : std_logic := '0';
    signal clk_n : std_logic := '1';
begin
    clk_p <= not clk_p after 2.0833333 ns;
    clk_n <= not clk_p;
   
    uut : entity work.top
            port map (sysclk_in_p => clk_p, sysclk_in_n => clk_n, rst => '0');

    pippo : process 
    begin
        wait for 100 ns;
        finish(0);
    end process;
end Behavioral;
