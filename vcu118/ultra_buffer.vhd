library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ultra_data_types.all;
use work.ultra_constants.all;

entity ultra_buffer is
   port(
       clk : in std_logic;
       rst : in std_logic;
       we  : in std_logic;
       tx_in : in ndata(3 downto 0);
       rx_out: out ndata(3 downto 0)
   );
end ultra_buffer;

architecture behavioral of ultra_buffer is
    attribute dont_touch : string;
    attribute dont_touch of behavioral : architecture is "yes";
    type mybuff is array (3 downto 0) of std_logic_vector(35 downto 0);
    signal inj_buff, cap_buff: mybuff;
    signal addr: std_logic_vector(13 downto 0);
begin

    gen_brams: for i in 3 downto 0 generate
        rx_bram : entity work.bram_sdp
            port map (wclk => '0', we => '0', waddr => (others => '0'), d => (others => '0'),
                      rclk => clk, raddr => addr, q => inj_buff(i));
        tx_bram : entity work.bram_sdp
            port map (wclk => clk, we => we, waddr => addr, d => cap_buff(i),
                      rclk => '0', raddr => (others => '0'), q => open);
    end generate;

    count: process(clk,rst)
    begin
        if rst = '1' then
            addr <= (others => '0');
        elsif rising_edge(clk) then
            if addr = b"00011111111111" then
                addr <= (others => '0');
            else
                addr <= std_logic_vector(unsigned(addr) + to_unsigned(1, 14));
            end if;
        end if;
    end process;

    get_out: process(clk)
    begin
        if rising_edge(clk) then
            for i in 3 downto 0 loop
                cap_buff(i)(31 downto  0) <= tx_in(i).data;
                cap_buff(i)(     32     ) <= tx_in(i).valid;
                cap_buff(i)(35 downto 33) <= (others => '0');
                rx_out(i).data  <= inj_buff(i)(31 downto 0);
                rx_out(i).valid <= inj_buff(i)(32);
            end loop;
        end if;
    end process;
end behavioral;

