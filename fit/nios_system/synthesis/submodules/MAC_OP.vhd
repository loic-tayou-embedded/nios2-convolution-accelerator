-- MAC_OP.vhd

LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

-- ---------------------------------------
    Entity MAC_OP is
-- ---------------------------------------
	Generic(
			N : integer := 32
	);
	port(
        clk, reset, start, clk_en : in std_logic;
        dataa, datab              : in std_logic_vector(N-1 downto 0);
        result                    : out std_logic_vector(N-1 downto 0);
        done                      : out std_logic
    );
	end MAC_OP;

-- ---------------------------------------
    Architecture MAC_OP_RTL of MAC_OP is
-- ---------------------------------------

component multiplier is
	Generic(
			N : integer := 32
	);
	Port(
			A, B : in  STD_LOGIC_VECTOR(N-1 downto 0);
			P    : out STD_LOGIC_VECTOR(2*N-1 downto 0)
	);
end component;

component ADDCN is
	Generic(
			N : integer := 32
	);
	port(
			I1, I2 : in std_logic_vector(N-1 downto 0);
			CIN    : in std_logic;
			SUM    : out std_logic_vector(N-1 downto 0); 
			COUT   : out std_logic
	);	 
end component;

type state_type is (IDLE, MULTIPLY, ACCUMULATE, FINISH);
signal state      : state_type := IDLE;
signal product    : std_logic_vector(2*N-1 downto 0);
signal accum, sum : std_logic_vector(N-1 downto 0);
signal reg_dataa, reg_datab : std_logic_vector(N-1 downto 0);

-- -------------------------------------

begin

	multiplier_pm :	multiplier 
					generic map(N => N) 
					port map(
								A => reg_dataa,
								B => reg_datab, 
								P => product
					);
					
	
	ADDCN_pm :	ADDCN
				generic map(N => N)
				port map(
							I1 => accum, 
							I2 => product(N-1 downto 0), 
							CIN => '0',  
							SUM => sum
				);
				
				
	process(clk, reset)
    begin
        if reset = '1' then
            state     <= IDLE;
            result    <= (others => '0');
            done      <= '0';
            accum     <= (others => '0');
            reg_dataa <= (others => '0');
            reg_datab <= (others => '0');
            
        elsif rising_edge(clk) then
			if clk_en = '1' then
				done <= '0';
            
				case state is
					when IDLE =>
						if start = '1' then
							reg_dataa <= dataa;
							reg_datab <= datab;
							state <= MULTIPLY;
						end if;
						
					when MULTIPLY =>
						state <= ACCUMULATE;
						
					when ACCUMULATE =>
						accum <= sum;
						state <= FINISH;
						
					when FINISH =>
						result <= accum;
						done   <= '1';
						state  <= IDLE;                   
				end case;
			end if;
        end if;
    end process;
			
end MAC_OP_RTL;

