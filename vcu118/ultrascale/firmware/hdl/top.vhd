library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

use work.ultra_data_types.all;
use work.ultra_constants.all;
use work.board_constants.all;

entity top is
 port (
    sysclk_in_p : in std_logic;
    sysclk_in_n : in std_logic;
    rst_in : in std_logic;
    leds : out std_logic_vector(1 downto 0)
  );
end top;

architecture Behavioral of top is
    signal sysclk_tmp, clk_p, rst, rst_p, rst_tmp, rst_meta, rst_buf : std_logic;

    signal data_to_algo   : ndata(4*N_QUADS-1 downto 0);
    signal data_from_algo : ndata(4*N_QUADS-1 downto 0);
begin

  clocks: entity work.ttc_clocks
  port map(
    clk40_in_p => sysclk_in_p,
    clk40_in_n => sysclk_in_n,
    clk_p40 => '1',
    clko_40 => open,
    clko_p => clk_p,
    clko_aux => open,
    rsto_40 => open,
    rsto_p => rst_p,
    rsto_aux => open,
    clko_40s => open,
    stopped => open,
    locked => open,
    rst_mmcm => rst_in,
    rsti => rst_in,  -- Using the same reset for MMCM and rest of board, may need to delay this reset a bit until MMCM is ready again.
    clksel => '1', -- Selecting LVDS inputs for now.
    psval => (others => '0'),
    psok => open,
    psen => '0'
  );

  blink: entity work.dummy_blinker
     port map(
          clk => clk_p,
          rst => rst,
          l1 => leds(0),
          l2 => leds(1)
     );

  gen_buffers: for Q in N_QUADS-1 downto 0 generate
      buffs : entity work.ultra_buffer
          port map(clk => clk_p, rst => rst, we => '1', rx_out => data_to_algo(4*(Q+1)-1 downto 4*Q), tx_in => data_from_algo(4*(Q+1)-1 downto 4*Q));
  end generate gen_buffers;

  algo: entity work.ultra_null_algo
      port map(clk => clk_p, rst => rst, d => data_to_algo, q => data_from_algo);

  rst_bufg:     BUFG port map ( I => rst_p, O => rst );

end Behavioral;
