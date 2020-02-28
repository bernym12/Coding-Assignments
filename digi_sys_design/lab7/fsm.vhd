
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
Type State_type is (S0, S1, S2, S3); -- Define the States
signal state : State_type;
signal C : STD_LOGIC_VECTOR(1 downto 0);  --Internal signal for output C, which is a binary representation of the current state
signal O : STD_LOGIC_VECTOR (3 downto 0); --Internal signal for output O, which is a one-cold representation of the current state
signal X,Y,Z,EN: STD_LOGIC; --Signals for the digital one-shot and enable
---------------------End template signals------------------------------

--Create any signals you need here (for example, you will need a signal to hold the next state logic for your flipflops)

begin

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

Cout <= C;
Oout <= O;

States: process(CLK)
begin
   
            
    if rising_edge(CLK) Then
    
    CASE state IS
        WHEN S0 =>
            if EN='1' then
                state <= S1;
          
             END IF;
             
        WHEN S1 =>
            if EN='1' then
                state <= S2;
                
             END IF;       
        WHEN S2 =>
            if EN='1' then
                state <= S3;
              
             END IF;       
        WHEN S3 =>
            if EN='1' then
                state <= S0;
           
             END IF;  
         WHEN others =>
            state <= S0;
               
    End CASE;
    if (RST = '1') Then
            state <= S0;
     end if; 
     end if;
end process;
    
Output: process(state)   
begin
    CASE state IS
        WHEN S0 =>
                C <= "00";
                O <= "1110";
             
        WHEN S1 =>
          
                C <= "01";
                O <= "1101";
              
        WHEN S2 =>
                C <= "10";
                O <= "1011";
        WHEN S3 =>
                C <= "11";
                O <= "0111";
        
    End CASE;
    end process;  
    
    
end Behavioral;
