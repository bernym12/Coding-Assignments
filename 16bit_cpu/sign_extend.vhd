
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity sign_extend is 
    
    Port (
            br_j_immed: in std_logic_vector(1 downto 0);
            DataIn: in std_logic_vector(11 downto 0);
          DataOut: out std_logic_vector(15 downto 0)); --data output
end sign_extend;

architecture behavior of sign_extend is
   
begin
    extension: process(br_j_immed, DataIn)
        begin
        if (br_j_immed = "00") then
            DataOut <=  std_logic_vector(resize(signed(DataIn(11 downto 8)), DataOut'length));
        elsif (br_j_immed = "01") then
            DataOut <=  std_logic_vector(resize(signed(DataIn(7 downto 0)), DataOut'length));
        else
            DataOut <=  std_logic_vector(resize(signed(DataIn(7 downto 5)), DataOut'length));
        end if;
    end process;
    
end behavior;