-- ttc_clocks
--
-- Clock generation for LHC clocks
--
-- Adapted from mp7fw code by Dave Newbold, June 2013

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library unisim;
use unisim.VComponents.all;

use work.ultra_constants.all;


entity ttc_clocks is
  port(
    clk40_in_p: in std_logic;  -- External LVDS clock
    clk40_in_n: in std_logic;
    clk_p40: in std_logic;  -- Internally generated 40 MHz clock
    clko_40: out std_logic;  -- We're always generating a 40 MHz clock
    clko_p: out std_logic;  -- Main board clock
    clko_aux: out std_logic_vector(2 downto 0);  -- User clocks
    rsto_40: out std_logic;
    rsto_p: out std_logic;
    rsto_aux: out std_logic_vector(2 downto 0);
    clko_40s: out std_logic;  -- 40 MHz clock, phase-shifted by 45 degrees
    stopped: out std_logic;
    locked: out std_logic;
    rst_mmcm: in std_logic;
    rsti: in std_logic;
    clksel: in std_logic;
    psen: in std_logic;
    psval: in std_logic_vector(11 downto 0);
    psok: out std_logic
  );

end ttc_clocks;

architecture rtl of ttc_clocks is

  signal clk40_bp, clk40_bp_u, clk_fb, clk_fb_fr, clk_p40_b: std_logic;
  signal clk40_u, clk_p_u, clk40s_u, clk40_i, clk_p_i: std_logic;
  signal clks_aux_u, clks_aux_i, rsto_aux_r: std_logic_vector(2 downto 0);
  signal locked_i, rsto_p_r: std_logic;

begin

-- Input buffers

  ibuf_clk40: IBUFGDS
    port map(
      i => clk40_in_p,
      ib => clk40_in_n,
      o => clk40_bp_u
    );

  bufr_clk40: BUFG
    port map(
      i => clk40_bp_u,
      o => clk40_bp
    );

-- MMCM

  mmcm: MMCME3_ADV
    generic map(
      clkin1_period => 25.0,
      clkin2_period => 25.0,
      clkfbout_mult_f => 4.0,  -- Setting VCO to frequency within [600, 1200] MHz (DS892 for Kintex Ultrascale)
      clkout1_divide => 4,
      clkout2_divide => 4,
      clkout2_phase => 45.0,  -- Used to sample TTC stream in MP7.
      clkout3_divide => 4 / CLOCK_RATIO,
      clkout4_divide => 4 / CLOCK_AUX_RATIO(0),
      clkout5_divide => 4 / CLOCK_AUX_RATIO(1),
      clkout6_divide => 4 / CLOCK_AUX_RATIO(2)
    )
    port map(
      clkin1 => clk40_bp,
      clkin2 => clk_p40,
      clkinsel => clksel,
      clkfbin => clk_fb,
      clkfbout => clk_fb,
      clkout1 => clk40_u,
      clkout2 => clk40s_u,
      clkout3 => clk_p_u,
      clkout4 => clks_aux_u(0),
      clkout5 => clks_aux_u(1),
      clkout6 => clks_aux_u(2),
      rst => rst_mmcm,
      pwrdwn => '0',
      clkinstopped => stopped,
      locked => locked_i,
      daddr => "0000000",
      di => X"0000",
      dwe => '0',
      den => '0',
      dclk => '0',
      psclk => clk40_i,
      psen => '0',
      psincdec => '0',
      psdone => open,
      cddcreq => '0'
    );

  locked <= locked_i;

-- Buffers

  bufg_40: BUFG
    port map(
      i => clk40_u,
      o => clk40_i
    );

  clko_40 <= clk40_i;

  process(clk40_i)
  begin
    if rising_edge(clk40_i) then
      rsto_40 <= rsti or not locked_i;
    end if;
  end process;

  bufg_p: BUFG
    port map(
      i => clk_p_u,
      o => clk_p_i
    );

  clko_p <= clk_p_i;

  process(clk_p_i)
  begin
    if rising_edge(clk_p_i) then
      rsto_p_r <= rsti or not locked_i; -- Disaster looms if tools duplicate this signal
      rsto_p <= rsto_p_r; -- Pipelining for high-fanout signal
    end if;
  end process;

  cgen: for i in 2 downto 0 generate

    bufg_aux: BUFG
      port map(
        i => clks_aux_u(i),
        o => clks_aux_i(i)
      );

    clko_aux(i) <= clks_aux_i(i);

    process(clks_aux_i(i))
    begin
      if rising_edge(clks_aux_i(i)) then
        rsto_aux_r(i) <= rsti or not locked_i; -- Disaster looms if tools duplicate this signal
        rsto_aux(i) <= rsto_aux_r(i); -- Pipelining for high-fanout signal
      end if;
    end process;

  end generate;

  bufr_40s: BUFH
    port map(
      i => clk40s_u,
      o => clko_40s
    );

end rtl;
