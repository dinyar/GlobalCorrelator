library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dummy_blinker is
    port ( 
        clk : in std_logic;
        rst : in std_logic;
        l1 : out std_logic;
        l2 : out std_logic
    );
end dummy_blinker;

architecture behavioral of dummy_blinker is
    signal c0 : unsigned(31 downto 0) := to_unsigned(0, 32);
    signal c1 : unsigned(31 downto 0) := to_unsigned(0, 32);
begin

    pippo0: process(clk)
    begin
       -- do not reset c0 intentionally
       if rising_edge(clk) then
          if c0(30) = '1' then
              c0 <= to_unsigned(0, c0'length);
          else
              c0 <= c0 + to_unsigned(1, c0'length);
          end if;
       end if;
   end process pippo0;

   pippo1: process(clk,rst)
   begin
       if rst = '1' then
          c1 <= to_unsigned(0, c1'length); 
       elsif rising_edge(clk) then
          if c1(30) = '1' then
              c1 <= to_unsigned(0, c1'length);
          else
              c1 <= c1 + to_unsigned(1, c1'length);
          end if;
       end if;
   end process pippo1;

   l1 <= c0(29);
   l2 <= c1(29);
end behavioral;
