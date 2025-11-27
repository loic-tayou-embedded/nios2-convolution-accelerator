	library ieee;
	use ieee.std_logic_1164.all;
	
	entity ADDC1 is
	port(
			A, B, CIN : in std_logic;
			SUM, COUT : out std_logic
		 );
	end entity ADDC1;
	
	architecture ADDC1_rtl of ADDC1 is
	
	begin
		SUM <= A xor B xor CIN;
		COUT <= (A and B) or (CIN and (A xor B));
		
	end architecture ADDC1_rtl;