library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity register_counter is
    generic (N : integer := 8);
    Port ( Din : in STD_LOGIC_Vector (N-1 downto 0);
           CE : in STD_LOGIC;
           M : in STD_LOGIC_Vector (1 downto 0);
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Q : out STD_LOGIC_Vector (N-1 downto 0));
end register_counter;
   
architecture Behavioral of register_counter is
     signal tmp: unsigned (N-1 downto 0);
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
                tmp <= tmp;
            end if;
    
            if (M = "01") then --Shift
               tmp <= shift_left(tmp,1);
               Q <= std_logic_vector(tmp);
            end if;
    
            if (M = "10") then --Count
                tmp <= tmp+1;
                Q <= std_logic_vector(tmp);
            end if;
    
            if (M = "11") then --Load
                tmp <= unsigned(Din);
                Q <= std_logic_vector(tmp);
                
            end if;
        end if;
    end if;
end if;
end process;
end Behavioral;
