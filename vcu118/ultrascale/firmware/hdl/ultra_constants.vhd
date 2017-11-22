library ieee;
use ieee.std_logic_1164.all;

use work.ultra_data_types.all;

package ultra_constants is

    -- Clock multipliers
    constant CLOCK_RATIO: integer := 6;
    constant CLOCK_AUX_RATIO: clock_ratio_array_t := (1, 2, 6); -- Producing 40 MHz, 80 MHz, and 240 MHz clocks.

    constant DUMMY_ANSWER : natural := 42;
end;
