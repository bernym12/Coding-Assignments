----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2020 12:19:43 PM
-- Design Name: 
-- Module Name: PC - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
    Port ( CLK : in STD_LOGIC;
           rst : in STD_LOGIC;
           WE, rts : in STD_LOGIC;
           immediate: in std_logic_vector(15 downto 0);
           sign_extend_select: in std_logic_vector(1 downto 0);
           br_eq, br_neg: in STD_LOGIC;
           instr_addr : out STD_LOGIC_vector(15 downto 0));
end PC;

architecture Behavioral of PC is
signal pc_current,pc1,pc_next, pc_return: std_logic_vector(15 downto 0) := "0000000000000000";
begin

Prog_count: process (CLK, WE, pc_current, pc1, pc_next)
begin
if (rst = '1') then
         pc_current <= x"0000";
elsif (rising_edge(CLK) and WE = '1') then
--    pc1 <= pc_current + "000000000001";
    if (br_eq = '1' or br_neg = '1') then
        pc_current <= pc_current + immediate;
    elsif (sign_extend_select = "01") then
        pc_return <= pc_current + x"0001";
        pc_current <= pc_current + immediate;
    elsif (rts = '1') then
        pc_current <= pc_return;
    else   
        pc_current <= pc_current + x"0001";
    end if;
  end if;
 end process;
instr_addr <= pc_current;
end Behavioral;
