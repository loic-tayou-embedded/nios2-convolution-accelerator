-- FILTRE_MOYENNEUR.vhd

LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  
-- ---------------------------------------
    Entity FILTRE_MOYENNEUR is
-- ---------------------------------------
    port(
        dataa  : in std_logic_vector(31 downto 0);
        datab  : in std_logic_vector(31 downto 0);
        result : out std_logic_vector(31 downto 0)
    );
end entity;

-- ----------------------------------------------------------------
    Architecture FILTRE_MOYENNEUR_rtl of FILTRE_MOYENNEUR is
-- ----------------------------------------------------------------

    constant W1 : integer := 3;  
    constant W2 : integer := 1;
	 signal res  : std_logic_vector(63 downto 0);

-- ----------------------------------------------------------------

begin

    res    <= std_logic_vector((unsigned(dataa) * W1 + unsigned(datab) * W2) srl 2);
	result <= res(31 downto 0);
	
end FILTRE_MOYENNEUR_rtl;