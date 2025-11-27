-- multiplier.vhd

LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

-- ---------------------------------------
    Entity multiplier is
-- ---------------------------------------
		Generic(
				N : integer := 32
		);
		Port(
				A, B : in  STD_LOGIC_VECTOR(N-1 downto 0);
				P    : out STD_LOGIC_VECTOR(2*N-1 downto 0)
		);
	end multiplier;

-- ---------------------------------------
    Architecture multiplier_rtl of multiplier is
-- ---------------------------------------

-- -------------------------------------
begin

    process(A, B)
        variable acc : unsigned(2*N-1 downto 0);
        variable tmp : unsigned(2*N-1 downto 0);
    begin
        acc := (others => '0');
        tmp := unsigned(resize(signed(A), 2*N));

        for i in 0 to N-1 loop
            if B(i) = '1' then
                acc := acc + tmp;
            end if;
            tmp := tmp sll 1;
        end loop;

        P <= std_logic_vector(acc);
    end process;
end multiplier_rtl;