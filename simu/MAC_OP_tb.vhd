-- MAC_OP_tb.vhd

LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

entity MAC_OP_tb is
end entity MAC_OP_tb;

architecture MAC_OP_tb_rtl of MAC_OP_tb is

constant N  : Natural := 32;
signal stop : boolean := FALSE;
signal clk, rst, mac_done, start, clk_en : std_logic;
signal dataa, datab, mac_result          : std_logic_vector(N-1 downto 0);

begin

MAC_OP_mp : entity work.MAC_OP 
			generic map(N => N)
			port map(
						clk        => clk,
						clk_en     => clk_en,
						reset      => rst, 
						start      => start, 
						dataa      => dataa, 
						datab      => datab, 
						result     => mac_result, 
						done       => mac_done
			);
			
CLOCK_PROCESS :	process
				begin
					while not stop loop
						clk <= '0';
						wait for 10 ns;
						clk <= '1';
						wait for 10 ns;
					end loop;
					wait;
				end process;
								
stimuli : 	process
			begin
				rst <= '1'; 
				wait for 20 ns; 
				rst <= '0';
				
				clk_en <= '1';
				dataa  <= std_logic_vector(to_unsigned(256, N));
				datab  <= std_logic_vector(to_unsigned(128, N));
				
				start  <= '1';
				wait for 20 ns;
				start  <= '0';

				wait until mac_done = '1';
				wait until mac_done = '0';
				clk_en <= '0';
				
				wait for 20 ns;
				
				clk_en <= '1';
				dataa  <= std_logic_vector(to_unsigned(128, N));
				datab  <= std_logic_vector(to_unsigned(256, N));
				
				start  <= '1';
				wait for 20 ns;
				start  <= '0';
				
				wait until mac_done = '1';
				wait until mac_done = '0';
				clk_en <= '0';
				
				assert mac_result = std_logic_vector(to_unsigned(65536, N)) report "Error on mac_result" severity warning;
				stop <= True;
				wait;
			end process stimuli;

								
end architecture MAC_OP_tb_rtl;

