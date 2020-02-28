library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
entity counter is
port (
   CLK: in std_logic;
   clk_1s: out std_logic
  );
end counter;
architecture Behavioral of counter is
signal counter: integer := 0;
signal clk_temp: std_logic := '0';
begin
 process(CLK)
 begin
  if(rising_edge(CLK)) then
   counter <= counter + 1;
   if (counter = 50000000) then
      clk_temp <= not clk_temp;
      counter <= 0;
   end if;
  end if;
  clk_1s <= clk_temp;
 end process;
end Behavioral;