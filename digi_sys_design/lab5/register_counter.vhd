----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/30/2019 01:27:09 PM
-- Design Name: 
-- Module Name: register_counter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity register_counter is
    generic (N : integer := 8);
    Port ( Din : in STD_LOGIC_Vector (N-1 downto 0);
           CE : in STD_LOGIC;
           M : in STD_LOGIC_Vector (1 downto 0);
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Q : inout STD_LOGIC_Vector (N-1 downto 0));
end register_counter;
   
architecture Behavioral of register_counter is
     signal shift: unsigned (N-1 downto 0);
begin
process(CLK)
begin
if rising_edge(CLK) then
    if (RST = '1') then
       Q <= (others => '0');
    end if;
    if (RST = '0') then
        if (CE = '1')  then
            if (M = "00") then --Hold
                Q <= Q;
            end if;
    
            if (M = "01") then --Shift
               shift <= unsigned(Q);
               shift <= shift_left(shift,1);
               Q <= std_logic_vector(shift);
            end if;
    
            if (M = "10") then --Count
                Q <=(Q+1);
            end if;
    
            if (M = "11") then --Load
                Q <= Din;
            end if;
        end if;
    end if;
end if;
end process;
end Behavioral;
