library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control is 
   
    Port (func_bit,rst: in std_logic;
          opcode: in std_logic_vector(3 downto 0);
          rs2_or_imm, branch, mem_to_reg, WE, reg_WE, rts, PC_WE: out std_logic;
          sign_extend: out std_logic_vector(1 downto 0);
          alu_code : out std_logic_vector(2 downto 0)); --data output
end control;



architecture behavior of control is
--if a branch instruction, then need to take bottom 4 bits so 00
--jump, all 8 bits, so 01
-- immed, only 7 bits, so 10
begin
    writing: process(opcode, func_bit)

        begin
           
            if (rst = '1') then
                rs2_or_imm <= '0';
                branch <= '0';
                mem_to_reg <= '0';
                WE <= '0';
                reg_WE <= '0';
                sign_extend <= "00";
                alu_code <= "000";
                rts <= '0';
                PC_WE <= '1';
            else
                case opcode is
                    when "0000" =>
                        alu_code <= "000";
                        rs2_or_imm <= '0';
                        branch <= '0';
                        mem_to_reg <= '0';
                        reg_WE <= '0';
                        WE <= '0';
                        rts <= '0';
                        PC_WE <= '0';
                    when "0001" =>
                        alu_code <= "000";
                        rs2_or_imm <= '0';
                        branch <= '0';
                        mem_to_reg <= '0';
                        reg_WE <= '0';
                        WE <= '0';
                        rts <= '0';
                        PC_WE <= '1';
                    when "0010" => 
                        alu_code <= "000";
                        rs2_or_imm <= '0';
                        branch <= '0';
                        mem_to_reg <= '0';
                        reg_WE <= '1';
                        WE <= '0';
                        rts <= '0';
                        PC_WE <= '1';
                    when "0011" => 
                        alu_code <= "001";
                        rs2_or_imm <= '0';
                        branch <= '0';
                        mem_to_reg <= '0';
                        reg_WE <= '1';
                        WE <= '0';
                        rts <= '0';
                        PC_WE <= '1';
                    when "0100" =>
                        alu_code <= "010";
                        rs2_or_imm <= '0';
                        branch <= '0';
                        mem_to_reg <= '0';
                        reg_WE <= '1';
                        WE <= '0';
                        rts <= '0';
                        PC_WE <= '1';
                    when "0101" =>
                        alu_code <= "011";
                        rs2_or_imm <= '0';
                        branch <= '0';
                        mem_to_reg <= '0';
                        reg_WE <= '1';
                        WE <= '0';
                        rts <= '0';
                        PC_WE <= '1';
                    when "0110" =>
                        alu_code <= "100";
                        rs2_or_imm <= '0';
                        branch <= '0';
                        mem_to_reg <= '0';
                        reg_WE <= '1';
                        WE <= '0';
                        rts <= '0';
                        PC_WE <= '1';
                    when "0111" =>
                        alu_code <= "101";
                        rs2_or_imm <= '0';
                        branch <= '0';
                        mem_to_reg <= '0';
                        reg_WE <= '1';
                        WE <= '0';
                        rts <= '0';
                        PC_WE <= '1';
                    when "1000" => --branch
                        alu_code <= "001";
                        rs2_or_imm <= '1';
                        branch <= '1';
                        mem_to_reg <= '0';
                        reg_WE <= '0';
                        WE <= '0';
                        rts <= '0';
                        PC_WE <= '1';
                        sign_extend <= "00";
                    when "1001" => --branch
                        alu_code <= "001";
                        rs2_or_imm <= '1';
                        branch <= '1';
                        mem_to_reg <= '0';
                        reg_WE <= '0';
                        WE <= '0';
                        rts <= '0';
                        PC_WE <= '1';
                        sign_extend <= "00";
                    when "1100" => 
                        if (func_bit = '0') then
                            alu_code <= "---";
                            rs2_or_imm <= '1';
                            branch <= '0';
                            mem_to_reg <= '1';
                            reg_WE <= '1';
                            WE <= '0';
                            rts <= '0';
                            PC_WE <= '1';
                        else
                            alu_code <= "---";
                            rs2_or_imm <= '1';
                            branch <= '0';
                            mem_to_reg <= '0';
                            reg_WE <= '1';
                            WE <= '1';
                            rts <= '0';
                            PC_WE <= '1';
                        end if;
                    when "1110" => --jump
                        alu_code <= "---";
                        rs2_or_imm <= '0';
                        branch <= '0';
                        mem_to_reg <= '0';
                        reg_WE <= '1';
                        WE <= '0';
                        sign_extend <= "01";
                        rts <= '0';
                        PC_WE <= '1';
                    when "1111" =>
                        alu_code <= "---";
                        rs2_or_imm <= '0';
                        branch <= '0';
                        mem_to_reg <= '0';
                        reg_WE <= '0';
                        WE <= '0';
                        rts <= '1';
                        PC_WE <= '1';
                    when "1011" => --immed
                        if (func_bit = '0') then
                            alu_code <= "000";
                            rs2_or_imm <= '1';
                        branch <= '0';
                        mem_to_reg <= '0';
                        reg_WE <= '1';
                        WE <= '0';
                        rts <= '0';
                        PC_WE <= '1';
                        sign_extend <= "10";
                        else
                            alu_code <= "001";
                            rs2_or_imm <= '1';
                        branch <= '0';
                        mem_to_reg <= '0';
                        reg_WE <= '1';
                        WE <= '0';
                        rts <= '0';
                        PC_WE <= '1';
                        sign_extend <= "10";
                        end if;
                        

                    when "1101" => --immed
                        if (func_bit = '0') then
                            alu_code <= "010"; 
                            rs2_or_imm <= '1';
                        branch <= '0';
                        mem_to_reg <= '0';
                        reg_WE <= '1';
                        WE <= '0';
                        rts <= '0';
                        PC_WE <= '1';
                        sign_extend <= "10";
                        else 
                            alu_code <= "011";
                             rs2_or_imm <= '1';
                        branch <= '0';
                        mem_to_reg <= '0';
                        reg_WE <= '1';
                        WE <= '0';
                        rts <= '0';
                        PC_WE <= '1';
                        sign_extend <= "10";
                        end if;
                       

                    when others => 
                        alu_code <= "000";
                        rs2_or_imm <= '0';
                        branch <= '0';
                        mem_to_reg <= '0';
                        reg_WE <= '0';
                        WE <= '0';
                        rts <= '0';
                        PC_WE <= '1';
                
                end case;
            end if;
    end process;
    
end behavior;