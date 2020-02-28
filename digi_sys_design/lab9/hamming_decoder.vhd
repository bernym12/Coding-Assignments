----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2019 04:36:58 PM
-- Design Name: 
-- Module Name: hamming_decoder - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with    Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hamming_decoder is
  Port (
  --err_loc: out  integer;  
  		clk: in std_logic;
        input: in std_logic_vector(7 downto 0); --layout of input (C1 C2 D1 C3 D2 D3 D4 C4)
        final: out std_logic_vector(3 downto 0);
        err_corrected: out std_logic;
        err_detected: out std_logic
        );
end hamming_decoder;

architecture Behavioral of hamming_decoder is
signal c1check: std_logic;
signal c2check: std_logic;
signal c3check: std_logic;
signal c4check: std_logic;
signal c1: std_logic;
signal c2: std_logic;
signal c3: std_logic;
signal c4: std_logic;
signal err_loc: integer := 0;
signal err_locb: std_logic_vector(2 downto 0) := (others => '0');
signal hold: std_logic_vector(7 downto 0) := (others => '0');
signal data: std_logic_vector(3 downto 0);
signal err_detect: std_logic;
signal err_correct: std_logic;	
signal fix_bit: std_logic;
begin


process(c1check, c2check, c3check, c4check)
begin	 
	c1 <= input(7);
    c2 <= input(6);
    c3 <= input(4);
    c4 <= input(0);
    data(0) <= input(5);
    data(1) <= input(3);
    data(2) <= input(2);
    data(3) <= input(1);	 
end process;

c1check <= data(0) xor data(1) xor data(3); --D1 xor D2 xorD4
c2check <= data(0) xor data(2) xor data(3); -- D1 xor D3 xor D4
c3check <= data(1) xor data(2) xor data(3); -- D2 xor D3 xor D4
c4check <= c1 xor c2 xor data(0) xor c3 xor data(1) xor data(2) xor data(3);  -- C1 xor C2 xor D1 xor C3 xor D2 xor D3 xor D4

check: process (c4check)
begin
    
        if (c4check = c4 and (c3check /= c3 or c2check /= c2 or c1check /= c1)) then
             err_detect <= '1';
             err_correct <= '0';
         else
            if (c3check /= c3 or c2check /= c2 or c1check /= c1) then
                err_locb(2) <= c3check;
                err_locb(1) <= c2check;
                err_locb(0) <= c1check;
                err_detect <= '0';
                err_correct <= '1';
            end if;	 
		end if;       	
end process check;
err_loc <= to_integer(unsigned(err_locb)) - 1;


process(clk, input, data)
begin 
	if (rising_edge(clk))  then
	if (err_loc = 5) then
		final(0) <= not data(0); 
		final(1) <= input(3);
		final(2) <= input(2);
		final(3) <= input(1); 
	else if (err_loc = 3) then	 
		final(0) <= input(5);
		final(1) <= not data(1);
		final(2) <= input(2);
		final(3) <= input(1);  
	else if (err_loc = 2) then	 
		final(0) <= input(5);
		final(1) <= input(3);
		final(2) <= not data(2);
		final(3) <= input(1);
	else if (err_loc = 1) then	 
		final(0) <=  input(5);
		final(1) <=  input(3);
		final(2) <=  input(2);
		final(3) <= not data(3); 
	else	
		final(0) <=  input(5);
		final(1) <=  input(3);
		final(2) <=  input(2);
		final(3) <=  input(1);	   
	end if;
	end if;	
	end if;
	end if;	
	end if;
		
end process;
err_detected <= err_detect;
err_corrected <= err_correct;

end Behavioral;
