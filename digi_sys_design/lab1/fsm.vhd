
----------------------------------------------------------------------------------
-- Engineer: Bernard Moussad
-- 
-- Create Date: 09/09/2019
-- Module Name: 
-- Project Name:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity Moore_FSM_Equations_FD is
    Port ( CLK : in STD_LOGIC;--Clock
           RST : in STD_LOGIC;--Active Low synchcronus reset
           PB : in STD_LOGIC;--Active High clock enable from pushbutton
           Cout : out STD_LOGIC_VECTOR (1 downto 0);--Binary representation fo the current state
           Oout : out STD_LOGIC_VECTOR (3 downto 0));--One-cold representation fo the current state
end Moore_FSM_Equations_FD;

architecture Behavioral of Moore_FSM_Equations_FD is
---------------------Begin template signals----------------------------
signal C : STD_LOGIC_VECTOR(1 downto 0);  --Internal signal for output C, which is a binary representation of the current state
signal O : STD_LOGIC_VECTOR (3 downto 0); --Internal signal for output O, which is a one-cold representation of the current state
signal X,Y,Z,EN: STD_LOGIC; --Signals for the digital one-shot and enable
---------------------End template signals------------------------------

--Create any signals you need here (for example, you will need a signal to hold the next state logic for your flipflops)

begin

-- Template for D flip-flop model
-- Copy and paste for each D flip-flop instance
-- Each instance must have a unique Instance_Label
-- Substitute actual signal names for clock-signal, Q-output, D-input
--
--Instance_Label :  process (clock-signal)
--                  begin
--                      if rising_edge(clock-signal) then
--                            Q-output <= D-input;
--                      end if;
--                  end process;


---------------------Begin digital one-shot model---------------------
---------------Study, but do not edit!--------------------------------

-- First D flip-flop of the one-shot circuit
ONESHOTFF1 : process (CLK)
			 begin	
				if rising_edge(CLK) then	-- trigger on rising clock edge
					X <= PB;			    -- PB = D-input, X = Q-output	
				end if;
			end process;
			
-- Second D flip-flop of the one-shot circuit
ONESHOTFF2 : process (CLK)
			 begin	
				if rising_edge(CLK) then	-- trigger on rising clock edge
					Y <= X;			        -- X = D-input, Y = Q-output	
				end if;
			end process;

-- Third D flip-flop of the one-shot circuit
ONESHOTFF3 : process (CLK)
			 begin	
				if rising_edge(CLK) then	-- trigger on rising clock edge
					Z <= Y;			        -- Y = D-input, Z = Q-output	
				end if;
			end process;

--Create enable signal with the output of the oneshot
EN <= Y and not Z;

---------------------End digital one-shot code---------------------


--Assigning internal signals to the outputs.
--"Why mirror the outputs with internal signals instead of just assigning directly to 
--the outputs?" Excellent question enquiring student! There are several reasons
--why you would want to use internal signals for everything, and then assign those
--signals to the outputs. In this case, the reason is that in VHDL, you cannot read
--the state of an output. This means that if we assign a value to an output port C
--  C <= A and B;
--You will get an error if you have another statement that tries to reference (read) C
--  Z <= C or Y;
Cout <= C;
Oout <= O;
---------------------Enter your code below-------------------------
--Here you should create any flipflops you need for your FSM design. 
--The clock should be tied to CLK ( as in the digital one-shot code).
--The data input should be supplied by your next state logic.
--The data output will be used in the next state logic and output logic.
--You will need to assign values C and O.
DC1 : process (CLK)
			 begin	
				if rising_edge(CLK) then	-- trigger on rising clock edge
					C(1) <= ((not EN and C(1)) or (EN and C(0))) and (not RST);			    -- PB = D-input, X = Q-output	
				end if;
			end process;
			
-- Second D flip-flop of the one-shot circuit
DC2 : process (CLK)
			 begin	
				if rising_edge(CLK) then	-- trigger on rising clock edge
				    C(0) <= ((EN and (not C(1))) or ((Not EN) and C(0))) and (not RST);  -- X = D-input, Y = Q-output	
				end if;
			end process;
O(3) <= (not C(1) and C(0)) and (not RST);
O(2) <= ((not C(1)) and (not C(0))) and (not RST);
O(1) <= (C(1) and (not C(0))) and (not RST);
O(0) <= (C(1) and C(0)) and (not RST);

end Behavioral;
