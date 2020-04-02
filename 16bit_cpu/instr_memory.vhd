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
 -- lw $3, 0($0) -- pc=0
 -- Loop: sltiu  $1, $3, 11= pc = 2
 -- beq $1, $0, Skip = 4 --PCnext=PC_current+2+BranchAddr
 -- add $4, $4, $3 = 6
 -- addi $3, $3, 1 = 8
 -- beq $0, $0, Loop--a
 -- Skip c = 12 = 4 + 2 + br
 type ROM_type is array (0 to 11 ) of std_logic_vector(15 downto 0);
 constant rom_data: ROM_type:=(
   "1001100010011011",
   "1001001110011011",
   "1000100001110011",
   "1001101010010100",
   "1011110010110101",
   "1101000111010110",
   "1101000111010111",
   "0000100100111110",
   "0010100100001000",
   "0000000000000000",
   "1001001110011011",
   "0000000000111111"
  );
begin

rom_addr <= pc(3 downto 0);
instruction <= rom_data(to_integer(unsigned(rom_addr))) when pc < x"0020" else x"0000";

end Behavioral;