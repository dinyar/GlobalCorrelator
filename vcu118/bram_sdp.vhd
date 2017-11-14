-- inspired from from cactus/components/mp7_links/firmware/hdl/common/buf_18kb.vhd
-- (original author Dave Newbold, July 2013)

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

entity bram_sdp is
    port(
        wclk: in std_logic;
        we: in std_logic;
        waddr: in std_logic_vector(13 downto 0);
        d: in std_logic_vector(35 downto 0);
        rclk: in std_logic;
        raddr: in std_logic_vector(13 downto 0);
        q: out std_logic_vector(35 downto 0)
    );
end bram_sdp;

architecture rtl of bram_sdp is
begin
    ram: RAMB18E1
        generic map(
            DOA_REG => 1,
            DOB_REG => 1,
            RAM_MODE => "SDP",
            READ_WIDTH_A => 36,
            WRITE_WIDTH_B => 36,
            WRITE_MODE_A => "READ_FIRST",
            WRITE_MODE_B => "READ_FIRST"
        )
        port map(
            ADDRARDADDR => raddr,
            ADDRBWRADDR => waddr,
            CLKARDCLK => rclk,
            CLKBWRCLK => wclk,
            DIADI => d(15 downto 0),
            DIBDI => d(31 downto 16),
            DIPADIP => d(33 downto 32),
            DIPBDIP => d(35 downto 34),
            DOADO => q(15 downto 0),
            DOBDO => q(31 downto 16),
            DOPADOP => q(33 downto 32),
            DOPBDOP => q(35 downto 34),
            ENARDEN => '1',
            ENBWREN => we,
            REGCEAREGCE => '1',
            REGCEB => '0',
            RSTRAMARSTRAM => '0',
            RSTRAMB => '0',
            RSTREGARSTREG => '0',
            RSTREGB => '0',
            WEA => "11",
            WEBWE => "1111"
        );
end rtl;


