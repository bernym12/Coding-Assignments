library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux is 
    generic (N : integer := 16);
    Port (selector : in std_logic; --selector bit
          A,B : in std_logic_vector(N-1 downto 0); --data inputs
          result : out std_logic_vector(N-1 downto 0)); --data output
end mux;

architecture behavior of mux is
    
begin
   process(selector, A, B)
        begin
            if (selector = '0') then
                result <= A;
            else
                result <= B;
            end if;
        end process;
 
    
end behavior;