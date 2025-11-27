-- TOP_LEVEL.vhd

LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

-- ---------------------------------------
    Entity TOP_LEVEL is
-- ---------------------------------------
	Port(     
			CLOCK_50 : In std_logic;
			KEY      : In std_logic_vector(3 downto 0);
			SW       : In std_logic_vector(7 downto 0);
			LEDR     : Out std_logic_vector(7 downto 0);
			DRAM_DQ  : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			DRAM_ADDR: Out   STD_LOGIC_VECTOR(11 DOWNTO 0);
			DRAM_BA_0, DRAM_BA_1 : OUT STD_LOGIC;
			DRAM_CAS_N, DRAM_RAS_N, DRAM_CLK : OUT STD_LOGIC;
			DRAM_CKE, DRAM_CS_N, DRAM_WE_N   : OUT STD_LOGIC;
			DRAM_UDQM, DRAM_LDQM             : OUT STD_LOGIC
		);
	end TOP_LEVEL;

-- ---------------------------------------
    Architecture TOP_LEVEL_RTL of TOP_LEVEL is
-- ---------------------------------------

 component nios_system is
	  port (
            clk_clk         : in    std_logic                     := 'X';             -- clk
            reset_reset_n   : in    std_logic                     := 'X';             -- reset_n
            switches_export : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- export
            leds_export     : out   std_logic_vector(7 downto 0);                     -- export
            sdram_addr      : out   std_logic_vector(11 downto 0);                    -- addr
            sdram_ba        : out   std_logic_vector(1 downto 0);                     -- ba
            sdram_cas_n     : out   std_logic;                                        -- cas_n
            sdram_cke       : out   std_logic;                                        -- cke
            sdram_cs_n      : out   std_logic;                                        -- cs_n
            sdram_dq        : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
            sdram_dqm       : out   std_logic_vector(1 downto 0);                     -- dqm
            sdram_ras_n     : out   std_logic;                                        -- ras_n
            sdram_we_n      : out   std_logic;                                        -- we_n
            sdram_clk_clk   : out   std_logic                                         -- clk
        );
 end component nios_system;
 
 SIGNAL DQM : STD_LOGIC_VECTOR(1 DOWNTO 0);
 SIGNAL BA  : STD_LOGIC_VECTOR(1 DOWNTO 0);

-- -------------------------------------

begin

 DRAM_BA_0 <= BA(0);
 DRAM_BA_1 <= BA(1);
 DRAM_UDQM <= DQM(1);
 DRAM_LDQM <= DQM(0);

 u0 : component nios_system
		port map (
						clk_clk         => CLOCK_50,       --      clk.clk
						reset_reset_n   => KEY(0),         --    reset.reset_n
						switches_export => SW,             -- switches.export
						leds_export     => LEDR,            --     leds.export
						sdram_addr      => DRAM_ADDR,      --     sdram.addr
						sdram_ba        => BA,        --          .ba
						sdram_cas_n     => DRAM_CAS_N,     --          .cas_n
						sdram_cke       => DRAM_CKE,       --          .cke
						sdram_cs_n      => DRAM_CS_N,      --          .cs_n
						sdram_dq        => DRAM_DQ,        --          .dq
						sdram_dqm       => DQM,
						sdram_ras_n     => DRAM_RAS_N,
						sdram_we_n      => DRAM_WE_N,
						sdram_clk_clk   => DRAM_CLK        -- sdram_clk.clk
		);
			
end TOP_LEVEL_RTL;

  


