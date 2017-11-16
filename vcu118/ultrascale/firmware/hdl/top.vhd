library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

use work.ultra_data_types.all;
use work.ultra_constants.all;

entity top is
 port (
    sysclk_in_p : in std_logic;
    sysclk_in_n : in std_logic;
    rst_in : in std_logic;
    leds : out std_logic_vector(1 downto 0)
  );
end top;

architecture Behavioral of top is
    signal sysclk_tmp, clk, rst, rst_tmp, rst_meta, rst_buf : std_logic;

    signal data_to_algo   : ndata(4*N_QUADS-1 downto 0);
    signal data_from_algo : ndata(4*N_QUADS-1 downto 0);
begin

IBUFGDS_sys : IBUFGDS
  port map ( I  => sysclk_in_p, IB => sysclk_in_n, O  => sysclk_tmp);

BUFG_syspre : BUFG
  port map ( I => sysclk_tmp, O => clk);
    
blink: entity work.dummy_blinker
   port map(
        clk => clk,
        rst => rst,
        l1 => leds(0),
        l2 => leds(1)
   );

gen_buffers: for Q in N_QUADS-1 downto 0 generate
    buffs : entity work.ultra_buffer
        port map(clk => clk, rst => rst, we => '1', rx_out => data_to_algo(4*(Q+1)-1 downto 4*Q), tx_in => data_from_algo(4*(Q+1)-1 downto 4*Q));
end generate gen_buffers;
 
algo: entity work.ultra_null_algo
    port map(clk => clk, rst => rst, d => data_to_algo, q => data_from_algo);

rst_button:   IBUF port map ( I => rst_in, O => rst_tmp );
rst_bridge_1: FDPE port map ( D => '0',      PRE => rst_tmp, CE => '1', C => clk, Q => rst_meta );
rst_bridge_2: FDPE port map ( D => rst_meta, PRE => rst_tmp, CE => '1', C => clk, Q => rst_buf );
rst_bufg:     BUFG port map ( I => rst_buf, O => rst );

end Behavioral;
