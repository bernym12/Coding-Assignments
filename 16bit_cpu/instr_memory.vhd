library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  

entity instr_mem is
port (
 pc: in std_logic_vector(15 downto 0);
 instruction: out  std_logic_vector(15 downto 0)
);
end instr_mem;

architecture Behavioral of instr_mem is
signal rom_addr: std_logic_vector(3 downto 0);
 type ROM_type is array (0 to 14) of std_logic_vector(15 downto 0);
 constant rom_data: ROM_type:=(
   "0000000000000000",
   "0101010101001100",
   "0010000001001100",
   "1001011010011011",
   "1001001110011011",
   "1000011110000011",
   "1010101110100100",
   "1100110011010101",
   "1110000111100110",
   "1110000111100111",
   "0011000000111110",
   "1001100100001000",
   "0000000000000000",
   "1001001110011011",
   "0000000000111111" 
  );
begin

rom_addr <= pc(3 downto 0);
instruction <= rom_data(to_integer(unsigned(rom_addr))) when pc < x"0020" else x"0000";

end Behavioral;