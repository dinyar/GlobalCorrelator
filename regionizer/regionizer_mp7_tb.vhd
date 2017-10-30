library std;
use std.textio.all;
use std.env.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

use work.pftm_data_types.all;
use work.pftm_constants.all;
use work.pftm_textio.all;
use work.pftm_mp7_textio.all;

entity testbench is
--  Port ( );
end testbench;

architecture Behavioral of testbench is
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal valid_in : std_logic;
    signal links_in : words32(N_SECTORS-1 downto 0);
    signal links_out : words32(2*N_OBJ-1 downto 0);
    signal valid_out : std_logic;
    --signal debug_in  : particles(N_SECTORS-1 downto 0);
    --signal debug_out : particles(N_OBJ-1 downto 0);     
    --signal debug_c   : natural range 0 to N_CLOCK-1;
    --signal debug_in_counter: natural range 0 to N_CLOCK-1;   -- counter in sync with input particles for the regionizer
    file FI : text open read_mode is "test-regionizer-mp7-in.txt";
    file FO : text open write_mode is "test-regionizer-mp7-out.txt";
    file FL : text open write_mode is "test-regionizer-log.txt";
begin
    clk  <= not clk after 2.0833333 ns;
    
    uut : entity work.regionizer_mp7
        port map(clk => clk, rst => rst, mp7_in => links_in, mp7_out => links_out, mp7_valid => valid_in, mp7_outv => valid_out); --, mp7_cnt => debug_c, debug_in => debug_in, debug_out => debug_out, debug_in_counter => debug_in_counter); 
   
    pippo : process 
        variable in_data : words32(N_SECTORS-1 downto 0);
        variable in_valid : std_logic;
        variable out_data : words32(2*N_OBJ-1 downto 0);
        variable out_valid : std_logic;
        variable remainingEvents : integer := 80;
        variable frame : integer := 0;
        variable L : line;
    begin
        rst <= '1';
        wait for 25 ns;
        rst <= '0';
        links_in <= (others => (others => '0'));
        wait until rising_edge(clk);
        while remainingEvents > 0 loop
            if not endfile(FI) then
                read_mp7_frame(FI, in_data, in_valid);
             else
                in_valid := '0'; 
                in_data := (others => (others => '0'));
                remainingEvents := remainingEvents - 1;
            end if;
            -- prepare stuff
            valid_in <= in_valid;
            links_in <= in_data;
            -- ready to dispatch ---
            wait until rising_edge(clk);
            frame := frame + 1;
            out_data := links_out; out_valid := valid_out;
            write_mp7_frame(FO, frame, out_data, out_valid);

            --write(L, string'("UNPACK: C ")); write(L, debug_in_counter,  field => 2);  write(L, string'("  D ")); 
            --for o in 0 to N_SECTORS-1 loop write(L, to_integer(debug_in(o).pt),  field => 6);  end loop;
            --write(L, string'(" | PP OUTPUT "));
            --for o in 0 to 7 loop -- N_OBJ-1 loop
            --    write(L, to_integer(debug_out(o).pt),  field => 6);  
            --end loop;
            --write(L, string'("... | PACK OUTPUT: C ")); write(L, debug_c, field=>2); 
            write(L, string'("  V ")); write(L, out_valid); write(L, string'(" |  "));
            for i in 0 to 7 loop --N_OBJ-1 loop
                hwrite(L, out_data(i)); write(L, string'("  "));
            end loop;
            write(L, string'("..."));
            writeline(FL, L);
        end loop;
        wait for 50 ns;
        finish(0);
    end process;

    
end Behavioral;
