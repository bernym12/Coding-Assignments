

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_divider is
    Port ( clk : in STD_LOGIC; --50 MHz
           clk200 : out STD_LOGIC; --3.125 MHz
           clkrx : out STD_LOGIC); --25 MHz
end clock_divider;

architecture Behavioral of clock_divider is
signal clock200: integer := 0;
signal clockrx: integer :=0;
signal clk200_temp: std_logic := '0';
signal clkrx_temp: std_logic := '0';

begin
    process(CLK)
    begin
    if(rising_edge(CLK)) then
        clock200 <= clock200 + 1;
        clockrx <= clockrx + 1;
    if (clock200 = 3124999) then
        clk200_temp <= not clk200_temp;
        clock200 <= 0;
    if (clockrx = 24999999) then
        clkrx_temp <= not clkrx_temp;
        clockrx <= 0;
    end if;
    end if;
    end if;
    clk200 <= clk200_temp;
    clkrx <= clkrx_temp;

    end process;

end Behavioral;
