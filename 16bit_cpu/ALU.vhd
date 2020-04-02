library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity ALU is 
   
    Port (operation: in std_logic_vector(2 downto 0);
          operand1, operand2: in std_logic_vector(15 downto 0);
          result: out std_logic_vector(15 downto 0);
          zero, neg: out std_logic);
    end ALU;

architecture behavior of ALU is
   
begin
    writing: process(operand1, operand2, operation)
		begin
                case operation is
                    when "000" => 
                        result <= operand1 + operand2;
                        neg <= '0';
                        zero <= '0';
                    when "001" => 
                        result <= operand1 - operand2;
                        if (operand1 > operand2) then
                            neg <= '0';
                            zero <= '0';
                        elsif (operand1 < operand2) then
                            neg <= '1';
                            zero <= '0';
                        else
                            neg <= '0';
                            zero <= '1';
                        end if;
                    when "010" => 
                        result <= operand1 and operand2;
                    when "011" => 
                        result <= operand1 or operand2;
                    when "100" => 
                        result <= std_logic_vector(unsigned(operand1) sll to_integer(unsigned(operand2)));
                    when "101" => 
                        result <= std_logic_vector(unsigned(operand1) srl to_integer(unsigned(operand2)));
                    when others =>
                        result <= operand1 + operand2;

                
                end case;
    end process;
    
end behavior;