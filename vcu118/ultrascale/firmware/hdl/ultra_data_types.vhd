library ieee;
use ieee.std_logic_1164.all;

package ultra_data_types is

  type clock_ratio_array_t is array(2 downto 0) of integer;

    type sdata is record
        data : std_logic_vector(31 downto 0);
        valid : std_logic;
    end record;
    type ndata is array (natural range <>) of sdata;
end;
