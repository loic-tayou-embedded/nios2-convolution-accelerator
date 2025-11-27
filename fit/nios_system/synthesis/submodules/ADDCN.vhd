-- ADDCN.vhd

LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

-- ---------------------------------------
    Entity ADDCN is
-- ---------------------------------------
	Generic(
			N : integer := 32
	);
	port(
			I1, I2 : in std_logic_vector(N-1 downto 0);
			CIN    : in std_logic;
			SUM    : out std_logic_vector(N-1 downto 0); 
			COUT   : out std_logic
	);
	 
end entity ADDCN;

-- ---------------------------------------
    Architecture ADDCN_rtl of ADDCN is
-- ---------------------------------------

component ADDC1 is
	port(
			A, B, CIN : in std_logic;
			SUM, COUT : out std_logic
	);
end component ADDC1;

signal sig_sum : std_logic_vector(N downto 0) := (others => '0');

-- -------------------------------------


begin
	sig_sum(0) <= CIN;
	COUT       <= sig_sum(N);
	ADDCN_i :	for i in 0 to N-1 generate
					ADDC1_I1 : 	ADDC1 
								port map (
											A    => I1(i),
											B    => I2(i),
											CIN  => sig_sum(i),
											SUM  => SUM(i),
											COUT => sig_sum(i+1)
								);
				end generate;
						  
						  
end architecture ADDCN_rtl;


	