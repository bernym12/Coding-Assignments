-----------------------------------------------------------
-- Heading template for each model
--
-- File name: OctalDecoder.vhd
-- Designer name: 
-- Date created:
--
-- Design description:
-- Converts a 3-bit binary number to seven-segment code
-- to drive a 7-segment display. 
-----------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- "entity" describes the interface to this component
entity OctalDecoder is
    port (
			--D2, D1, D0    : in  STD_LOGIC;   --These define the three decoder inputs. 
			--A,B,C,D,E,F,G : out STD_LOGIC    --These define the outputs, one for each segment.
			                                 --Feel free to rename signals to match your prelab.
			
			--To use vectors rather than bits, comment out the lines with D2-0 and A-G
			--Uncomment the following two lines 
			D        : in  STD_LOGIC_VECTOR (2 downto 0);
            Segments : out  STD_LOGIC_VECTOR (6 downto 0)
			);
end OctalDecoder;

-- "architecture" describes the implementation of this component
architecture Behavioral of OctalDecoder is

begin

--For each output signal, fill in the logic equations derived in your prelab.
--Logic operators are spelled out: NOT, AND, OR, NAND, NOR, XOR, XNOR (upper or lower case)
--The binary operators all have the same precedance; unary operator NOT has higher precedence 
--Operators are evaluated left to right, so use parantheses to ensure correct evalation order!!!
--
--   Example: A<= (D1 and not D2) or D0;

--A <= not (D1 or (D2 and D0) or (not D2 and not D0)) ;
--B <= not((not D2) or  (not D1 and not D0) or (D1 and D0)) ;
--C <= not (D2 or (not D1) or D0);
--D <= not ((not D2 and not D0) or (D2 and not D1 and D0) or (not D2 and D1) or (D1 and not D0));
--E <= not ((not D2 and not D0) or (D1 and not D0));
--F <=  not ((not D1 and not D0) or (D2 and not D1) or (D2 and not D0));
--G <= not ((D2 and not D1) or (not D2 and D1) or (D1 and not D0));

--To use vectors, the process is exactly the same, but instead of individual bits,
--   specify bits within a vector via parantheses; Example: D(1). 
--   Comment out the above lines defining A-G and uncomment the lines for 
--   Segments(6)- Segments(0).
--
--Example: Segments(6) <= (D(1) and not D(2)) or D(0);
--
Segments(6) <= not (D(1) or (D(2) and D(0)) or (not D(2) and not D(0))) ;
Segments(5) <= not((not D(2)) or  (not D(1) and not D(0)) or (D(1) and D(0))) ;
Segments(4) <= not (D(2) or (not D(1)) or D(0));
Segments(3) <= not ((not D(2) and not D(0)) or (D(2) and not D(1) and D(0)) or (not D(2) and D(1)) or (D(1) and not D(0)));
Segments(2) <= not ((not D(2) and not D(0)) or (D(1) and not D(0)));
Segments(1) <=  not ((not D(1) and not D(0)) or (D(2) and not D(1)) or (D(2) and not D(0)));
Segments(0) <= not ((D(2) and not D(1)) or (not D(2) and D(1)) or (D(1) and not D(0)));
--  <=  ;
-- Segments(3) <=  ;
-- Segments(2) <=  ;
-- Segments(1) <=  ;
-- Segments(0) <=  ;

end Behavioral;