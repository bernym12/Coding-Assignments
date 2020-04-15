library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity data_mem is
port (
 address: in std_logic_vector(15 downto 0);
 datain: in  std_logic_vector(15 downto 0);
 dataout: out  std_logic_vector(15 downto 0);
 WE, clk, rst: in std_logic
);
end data_mem;
   
architecture Behavioral of data_mem is
--signal rom_addr: std_logic_vector(3 downto 0);

 type ram_type is array (0 to 1024) of std_logic_vector(15 downto 0);
signal RAM: ram_type :=((others=> (others=>'0')));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if WE = '1' then
                RAM(conv_integer(address)) <= datain;                
            end if;
        end if;
    end process;
dataout <= RAM(conv_integer(address(9 downto 0)));
end Behavioral;