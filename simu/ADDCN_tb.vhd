-- ADDCN_tb.vhd

LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

entity ADDCN_tb is
end entity ADDCN_tb;

architecture ADDCN_tb_rtl of ADDCN_tb is
constant N         : Natural := 32;
signal i1, i2, sum : std_logic_vector(N-1 downto 0);
signal cin, cout   : std_logic;

begin

ADDCN_pm :	entity work.ADDCN
			generic map(N => N)
			port map(
						I1  => i1, 
						I2  => i2, 
						CIN => cin,
						COUT=> cout,
						SUM => sum
			);
			
								
stimuli : process
			 begin
				cin <= '0';
				i1 <= (others => '1');
				i2 <= std_logic_vector(to_unsigned(1, N));

				wait for 10 ns;
				
				assert sum  = std_logic_vector(to_unsigned(0, N)) report "Error on SUM" severity warning;
				assert cout = '1' report "Error on COUT" severity warning;
				
				wait;
				end process stimuli;

								
end architecture ADDCN_tb_rtl;

