----------------------------------------------------------------------------------
-- John Whaley
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Top is
Port (
    keypad : in std_logic_vector(3 downto 0);
    errors : in std_logic_vector(1 downto 0);
    output : out std_logic;
    enable : in std_logic;
    clk : in std_logic -- 50 MHz clock signal
);
end Top;

architecture Behavioral of Top is
signal bitsOut : std_logic_vector(8 downto 0);
signal clk40 : std_logic; -- this will store the 3.125 MHz clock signal
signal counter: integer := 0;
signal bitnum: integer := 9;
signal clk_temp: std_logic := '0';
signal Byte_ready: std_logic; -- assertion loads the data into the register
signal T_byte: std_logic; -- ready to transmit?
signal Load_XMT_shiftreg: std_logic; -- assertion to load from keypad to data_reg
signal start: std_logic;
signal shift: std_logic;
signal clear: std_logic;
signal deb: std_logic;
signal X, Y, Z: std_logic;

begin

-- First D flip-flop of the one-shot circuit
ONESHOTFF1 : process (clk)
			 begin	
				if rising_edge(clk) then	-- trigger on rising clock edge
					X <= enable;			    -- PB = D-input, X = Q-output	
				end if;
			end process;
			
-- Second D flip-flop of the one-shot circuit
ONESHOTFF2 : process (clk)
			 begin	
				if rising_edge(clk) then	-- trigger on rising clock edge
					Y <= X;			        -- X = D-input, Y = Q-output	
				end if;
			end process;

-- Third D flip-flop of the one-shot circuit
ONESHOTFF3 : process (CLK)
			 begin	
				if rising_edge(clk) then	-- trigger on rising clock edge
				    deb <= Y;
				    if (Byte_ready = '1') then
					    T_byte <= '1'; 	
				    else 
				        T_byte <= '0';
				    end if;    
				end if;
			end process;


-- This process creates the clock signal for the keypad interface
-- This clock is also the transmission rate
newClk: process(CLK) begin
    if rising_edge(CLK) then
        counter <= counter + 1;
        if (counter = 16) then
            clk_temp <= not clk_temp;
            counter <= 0;
            clk40 <= clk_temp;
        end if;         
    end if;
end process;

dataIn: process(deb) begin
    if rising_edge(deb) then
        if errors = "00" then -- 0 errors in transmission
            Case keypad is
                when "0000" => bitsout <= "000000000";
                when "0001" => bitsout <= "111000010";
                when "0010" => bitsout <= "100110010";
                when "0011" => bitsout <= "011110000";
                when "0100" => bitsout <= "010101010";
                when "0101" => bitsout <= "101101000";
                when "0110" => bitsout <= "110011000";
                when "0111" => bitsout <= "001011010";
                when "1000" => bitsout <= "110100100";
                when "1001" => bitsout <= "001100110";
                when "1010" => bitsout <= "010010110";
                when "1011" => bitsout <= "101010100";
                when "1100" => bitsout <= "100001110";
                when "1101" => bitsout <= "011001100";
                when "1110" => bitsout <= "000111100";
                when "1111" => bitsout <= "111111110";
                when others => null;
        end case;   
        elsif errors = "01" then -- 1 error in transmission
            Case keypad is
                when "0000" => bitsout <= "000000010";
                when "0001" => bitsout <= "111000000";
                when "0010" => bitsout <= "100110000";
                when "0011" => bitsout <= "011110010";
                when "0100" => bitsout <= "010101000";
                when "0101" => bitsout <= "101101010";
                when "0110" => bitsout <= "110011010";
                when "0111" => bitsout <= "001011000";
                when "1000" => bitsout <= "110100110";
                when "1001" => bitsout <= "001100100";
                when "1010" => bitsout <= "010010100";
                when "1011" => bitsout <= "101010110";
                when "1100" => bitsout <= "100001100";
                when "1101" => bitsout <= "011001110";
                when "1110" => bitsout <= "000111110";
                when "1111" => bitsout <= "111111100";
                when others => null;
           end case;
        else -- 2 errors in transmission
            Case keypad is
                when "0000" => bitsout <= "000100010";
                when "0001" => bitsout <= "111100000";
                when "0010" => bitsout <= "100010000";
                when "0011" => bitsout <= "011010010";
                when "0100" => bitsout <= "010001000";
                when "0101" => bitsout <= "101001010";
                when "0110" => bitsout <= "110111010";
                when "0111" => bitsout <= "001111000";
                when "1000" => bitsout <= "110000110";
                when "1001" => bitsout <= "001000100";
                when "1010" => bitsout <= "010110100";
                when "1011" => bitsout <= "101110110";
                when "1100" => bitsout <= "100101100";
                when "1101" => bitsout <= "011101110";
                when "1110" => bitsout <= "000011110";
                when "1111" => bitsout <= "111011100";
                when others => null;
           end case;
        end if;
        
        --T_Byte <= '1'; 
    end if;
end process;

transmit: process(clk40) begin
    if rising_edge(clk40) then
        if T_byte = '1' then
            if (bitnum = 9) then
                output <= '0';
                bitnum <= bitnum - 1;
            elsif (bitnum >= 0) then 
                output <= bitsout(bitnum);
                bitnum <= bitnum - 1;
            end if;
        else 
            output <= '1';
            bitnum <= 9;
        end if;
    end if;
end process;

end Behavioral;
