----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2020 01:59:05 PM
-- Design Name: 
-- Module Name: top - Behavioral
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY top IS
    PORT (
        CLK, rst : IN std_logic
        -- instruction: IN std_logic_vector(15 downto 0);
        -- read_bus, write_bus : IN std_logic_vector(15 DOWNTO 0);
        -- address : IN std_logic_vector(10 DOWNTO 0)
    );
END top;

ARCHITECTURE Behavioral OF top IS

component PC is
    Port ( CLK : in STD_LOGIC;
           rst : in STD_LOGIC;
           WE, rts : in STD_LOGIC;
           immediate: in std_logic_vector(15 downto 0);
           sign_extend_select: in std_logic_vector(1 downto 0);
           br_eq, br_neg: in STD_LOGIC;
           instr_addr : out STD_LOGIC_vector(15 downto 0));
end component;

    component instr_mem is
        port (
            pc: in std_logic_vector(15 downto 0);
            instruction: out  std_logic_vector(15 downto 0)
        );
        end component;
    component sign_extend IS
        PORT (
            br_j_immed: in std_logic_vector(1 downto 0);
            DataIn: in std_logic_vector(11 downto 0);
            DataOut: out std_logic_vector(15 downto 0)); --data output
    end component;

    component ALU IS
        Port (operation: in std_logic_vector(2 downto 0);
            operand1, operand2: in std_logic_vector(15 downto 0);
            result: out std_logic_vector(15 downto 0);
            zero, neg: out std_logic);
    end component;
    
    component control IS
        Port (func_bit,rst: in std_logic;
              opcode: in std_logic_vector(3 downto 0);
              rs2_or_imm, branch, mem_to_reg, WE, reg_WE, rts, PC_WE: out std_logic;
              sign_extend: out std_logic_vector(1 downto 0);
              alu_code : out std_logic_vector(2 downto 0)); --data output
    end component;
       
    
    component mux is
        generic (N : integer := 16);
        Port (selector : in std_logic; --selector bit
            A,B : in std_logic_vector(N-1 downto 0); --data inputs
            result : out std_logic_vector(N-1 downto 0)); --data output
    end component;

    component reg is 
        generic (N : integer := 16;
                M : integer := 4);
        Port (WE, CLK, rst : in std_logic; --write enable
        DataIn : in std_logic_vector(N-1 downto 0); --data inputs
        RA1, RA2: in std_logic_vector(M-1 downto 0); -- read address
        Address : in std_logic_vector(M-1 downto 0); --address to read/write to
        DataOut1, DataOut2 : out std_logic_vector(N-1 downto 0)); --data output
    end component;

    SIGNAL pc_current, pc_next, pc1, pc_return : std_logic_vector(15 DOWNTO 0) := "0000000000000000";
    SIGNAL instruction : std_logic_vector(15 DOWNTO 0);
    --Control unit output signals
    SIGNAL reg_WE, PC_WE, WE, rts, mem_to_reg, branch, rs2_or_imm: std_logic;
    SIGNAL sign_extend_select: std_logic_vector(1 DOWNTO 0);
    SIGNAL alu_code : std_logic_vector(2 DOWNTO 0);
    --ALU output signals
    signal result:  std_logic_vector(15 downto 0);
    signal zero, neg:  std_logic;
    --sign extend output signals
    signal immediate:  std_logic_vector(15 downto 0); 
    --Data Input determined by mux for register file
    signal reg_data_input: std_logic_vector(15 downto 0);
    Signal regDataOut1, regDataOut2:  std_logic_vector(15 downto 0);

    --second operand for ALU, RS2 or immediate value
    signal rs2_or_imm_mux: std_logic_vector(15 downto 0);

    signal mem_data_out: std_logic_vector(15 downto 0);

    signal br_if_eq, br_if_neg: std_logic;
BEGIN
--PC for processor
-- prog_count: process(CLK, rst)
-- begin
--     if (rst = '1') then
--         pc_current <= x"0000";
--     elsif(rising_edge(CLK)) then
--         pc_current <= pc_next;
--     end if;
-- end process;

br_if_eq <= branch and zero;
br_if_neg <= branch and neg;

prog_count: PC 
    port map(
            CLK => CLK,
           rst=> rst,
           WE=>PC_WE,
           rts=>rts,
           immediate=>immediate,
           sign_extend_select=>sign_extend_select,
           br_eq=> br_if_eq,
           br_neg=>br_if_neg,
           instr_addr=>pc_current
           );
    
--Prog_count: process (CLK, PC_WE, pc_current, pc1, pc_next)
--begin
--if (rst = '1') then
--         pc_current <= x"0000";
--elsif (rising_edge(CLK) and PC_WE = '1') then
----    pc1 <= pc_current + "000000000001";
--    if (br_if_eq = '1' or br_if_neg = '1') then
--        pc_current <= pc_current + immediate;
--    elsif (sign_extend_select = "01") then
--        pc_return <= pc_current + x"0001";
--        pc_current <= pc_current + immediate;
--    elsif (rts = '1') then
--        pc_current <= pc_return;
--    else   
--        pc_current <= pc_current + x"0001";
--    end if;
--  end if;
-- end process;
-- pc_current <= pc_next;

--PC + 1
--    prog_count: PC
--    Port map ( 
--            CLK => CLK,
--            rst => rst,
--            WE => PC_WE,
--            next_addr=>pc_next,
--            instr_addr=>pc_current
--        );

    ram: reg
    port map
        (rst => rst,
        CLK => CLK,
        DataIn => reg_data_input,
        RA1 => instruction(7 downto 4),
        RA2 => instruction(11 downto 8),
        Address => instruction(15 downto 12),
        DataOut1 => regDataOut1, 
        DataOut2 => regDataOut2, 
        WE => reg_WE);

instruction_mem: instr_mem
    port map
    (pc=> pc_current,
    instruction=>instruction
    );
    
control_logic: control
    port map
    (rst => rst,
    opcode =>instruction(3 downto 0),
    func_bit=>instruction(8),
    rs2_or_imm => rs2_or_imm,
    branch => branch,
    mem_to_reg => mem_to_reg,
    WE => WE,
    reg_WE => reg_WE,
    rts => rts,
    PC_WE => PC_WE,
    alu_code => alu_code,
    sign_extend => sign_extend_select); 

alu_logic: ALU
    port map
    (operation => alu_code,
    operand1 => regDataOut1,
    operand2 => rs2_or_imm_mux,
    result => result,
    zero => zero,
    neg => neg); 

rs2_imm_mux: mux
    port map
    (selector => rs2_or_imm,
    A=>regDataOut2,
    B=>immediate,
    result=>rs2_or_imm_mux);
    
mem_to_reg_mux: mux
    port map
    (selector => mem_to_reg,
    A=>result,
    B=>mem_data_out,
    result=>reg_data_input);
    
sign_extender: sign_extend
    port map
    (br_j_immed => sign_extend_select,
    DataIn => instruction(15 downto 4),
    DataOut => immediate);



END Behavioral;