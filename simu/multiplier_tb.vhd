-- multiplier_tb.vhd

LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

entity multiplier_tb is
end entity multiplier_tb;

architecture multiplier_tb_rtl of multiplier_tb is
constant N          : Natural := 32;
signal dataa, datab : std_logic_vector(N-1 downto 0);
signal P            : std_logic_vector(2*N-1 downto 0);

begin

multiplier_pm :	entity work.multiplier 
				generic map(N => N) 
				port map(
							A => dataa,
							B => datab, 
							P => P
				);
			
								
stimuli : process
			 begin
				dataa <= std_logic_vector(to_unsigned(256, N));
				datab <= std_logic_vector(to_unsigned(128, N));

				wait for 10 ns;
				
				assert P = std_logic_vector(to_unsigned(32_768, 2*N)) report "Error on P" severity warning;
				
				wait;
				end process stimuli;

								
end architecture multiplier_tb_rtl;

