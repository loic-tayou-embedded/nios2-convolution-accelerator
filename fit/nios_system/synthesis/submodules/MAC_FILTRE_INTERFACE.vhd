-- MAC_FILTRE_INTERFACE.vhd

LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  
-- ---------------------------------------
    Entity MAC_FILTRE_INTERFACE is
-- ---------------------------------------
    port(
        dataa  : in std_logic_vector(31 downto 0);
        datab  : in std_logic_vector(31 downto 0);
        n      : in std_logic_vector(7 downto 0);
        result : out std_logic_vector(31 downto 0);
        clk    : in std_logic;
		clk_en : in std_logic;
        reset  : in std_logic;
        start  : in std_logic;
        done   : out std_logic
    );
end entity;

-- -------------------------------------------------------------------------------
    Architecture MAC_FILTRE_INTERFACE_rtl of MAC_FILTRE_INTERFACE is
-- -------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------
    
component FILTRE_MOYENNEUR is
    port(
        dataa  : in std_logic_vector(31 downto 0);
        datab  : in std_logic_vector(31 downto 0);
        result : out std_logic_vector(31 downto 0)
    );
end component;

    
component MAC_OP is
	Generic(
			N : integer := 32
	);
	port(
        clk, reset, start, clk_en : in std_logic;
        dataa, datab              : in std_logic_vector(N-1 downto 0);
        result                    : out std_logic_vector(N-1 downto 0);
        done                      : out std_logic
    );
end component;
    
signal filtre_result   : std_logic_vector(31 downto 0);
signal mac_result      : std_logic_vector(31 downto 0);
signal mac_done        : std_logic;

-- -------------------------------------------------------------------------------
   
begin

    FILTRE_MOYENNEUR_mp : 	FILTRE_MOYENNEUR 
							port map(
										dataa  => dataa, 
										datab  => datab, 
										result => filtre_result
							);
							
    MAC_OP_mp : MAC_OP 
				generic map(N => 32)
				port map(
							clk        => clk, 
							clk_en     => clk_en,
							reset      => reset, 
							start      => start, 
							dataa      => dataa, 
							datab      => datab, 
							result     => mac_result, 
							done       => mac_done
				);
    
    process(n, filtre_result, mac_result, mac_done)
    begin
        case n(0) is
            when '0' =>
                result <= filtre_result;
                done   <= '1';  -- Toujours à 1 pour combinatoire
            when '1' =>
				result <= mac_result;
                done   <= mac_done;
            when others =>
                result <= (others => '0');
                done   <= '0';
        end case;
    end process;
    
end MAC_FILTRE_INTERFACE_rtl;