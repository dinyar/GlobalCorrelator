library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pftm_data_types.all;
use work.pftm_constants.all;

entity regionizer_mp7 is
    port(
        clk : in std_logic;
        rst : in std_logic;
        mp7_valid : in std_logic;                     -- 1 if words are valid (we assume it's the same for all of them)
        mp7_in    : in  words32(N_SECTORS-1 downto 0); -- input particles 
        mp7_out   : out words32(2*N_OBJ-1 downto 0);   -- output particles
        mp7_outv  : out std_logic                     -- true if mp7_out contains valid data
        --mp7_cnt   : out natural range 0 to N_CLOCK-1; -- number of the region in mp7_out
    );
end regionizer_mp7;

architecture Behavioral of regionizer_mp7 is
    signal valid_in  : std_logic; -- whether I had an input valid frame before this
    signal in_buffer : words32(N_SECTORS-1 downto 0); -- buffers of input data (we need two words to make one particle)
    signal read_in  : std_logic;                       -- whether we're sending data to the regionizer to be read 
    signal links_in : particles(N_SECTORS-1 downto 0); -- input particles for the regionizer
    signal in_counter: natural range 0 to N_CLOCK-1;   -- counter in sync with input particles for the regionizer
    signal objs_out : particles(N_OBJ-1 downto 0);     -- particles in output from the regionizer
    signal valid_out : std_logic;                      -- valid output from the regionizer
    --signal out_counter : natural range 0 to N_CLOCK-1; -- number of the region in mp7_out
begin
    regionizer : entity work.regionizer_full
        port map(clk => clk, rst => rst, 
                 counter_in => in_counter, read_in => read_in, data_in => links_in, 
                 data_out => objs_out, valid_out => valid_out); --, counter_out => out_counter);

    process_input: process(clk,rst)
    begin
        if rst = '1' then
            valid_in <= '0';
            read_in <= '0';
        elsif rising_edge(clk) then
            if valid_in = '0' and mp7_valid = '1' then
                in_buffer <= mp7_in;
                valid_in <= '1';
                read_in <= '0';
                in_counter <= 0;
            elsif mp7_valid = '1' then
                if read_in = '1' then -- first frame of the N+1'th wagon: just refill buffer and increase counter
                    read_in <= '0';
                    in_buffer <= mp7_in;
                    if in_counter < N_IN_CLOCK-1 then in_counter <= in_counter + 1; else in_counter <= 0; end if;
                else
                    read_in <= '1';
                    for i in N_SECTORS-1 downto 0 loop
                        links_in(i) <= to_particle(mp7_in(i), in_buffer(i));
                    end loop;
                end if;
            else 
                read_in <= '0';
                valid_in <= '0';
            end if;
        end if;
    end process;

    mp7_outv <= valid_out;
    --mp7_cnt <= out_counter;
    encode_out: for i in N_OBJ-1 downto 0 generate
                    mp7_out(2*i+0) <= to_32b_lo(objs_out(i));
                    mp7_out(2*i+1) <= to_32b_hi(objs_out(i));
    end generate;
    -- --- version below with output buffered into registers (not clear if useful)
    -- process_output: process(clk)
    -- begin
    --     if rising_edge(clk) then
    --         if valid_out = '1' then
    --             mp7_outv <= '1';
    --             for i in N_OBJ-1 downto 0 loop
    --                 mp7_out(2*i+0) <= to_32b_lo(objs_out(i));
    --                 mp7_out(2*i+1) <= to_32b_hi(objs_out(i));
    --             end loop;
    --             -- mp7_cnt <= out_counter;
    --         else
    --             -- report "This shouldn't happen either, at least after some time";
    --             mp7_outv <= '0';
    --             mp7_out <= (others => (others => '0'));
    --             -- mp7_cnt <= out_counter;
    --         end if;
    --     end if;
    -- end process;

end Behavioral;
        

