
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity one_shot is
    Port ( CLK : in STD_LOGIC;--Clock
           RST : in STD_LOGIC;--Active Low synchcronus reset
           PB : in STD_LOGIC);--Active High clock enable from pushbutton
end one_shot;

architecture Behavioral of one_shot is
    signal X,Y,Z,EN: STD_LOGIC; --Signals for the digital one-shot and enable

begin
process(CLK)
begin
-- First D flip-flop of the one-shot circuit
ONESHOTFF1 : 	
				if rising_edge(CLK) then	-- trigger on rising clock edge
					X <= PB;			    -- PB = D-input, X = Q-output	
				end if;
			
			
-- Second D flip-flop of the one-shot circuit
ONESHOTFF2 : 	
				if rising_edge(CLK) then	-- trigger on rising clock edge
					Y <= X;			        -- X = D-input, Y = Q-output	
				end if;
			

-- Third D flip-flop of the one-shot circuit
ONESHOTFF3 : 	
				if rising_edge(CLK) then	-- trigger on rising clock edge
					Z <= Y;			        -- Y = D-input, Z = Q-output	
				end if;
			

--Create enable signal with the output of the oneshot
EN <= Y and not Z;
end process;
end Behavioral;