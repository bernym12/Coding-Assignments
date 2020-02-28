
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity clock_logic is
    Port (CLK: in std_logic;
          clk_1s: in std_logic;
          btn_min0, btn_min1, btn_h: in std_logic;
          AN: out std_logic_vector(3 downto 0);
          Segments: out std_logic_vector(6 downto 0);
          ALRM: in std_logic;
          LED: out std_logic;
          RST: in std_logic
         );
end clock_logic;

architecture Behavioral of clock_logic is 
    signal sec: integer range 0 to 60 := 0;
    signal min0, hour0: integer range 0 to 13 := 0;
    signal min1: integer range 0 to 6 := 0;
    signal count1: integer :=0;
    signal A_counter: integer range 0 to 3 :=0;
    signal tmp_AN: std_logic_vector (3 downto 0);
    signal min0A: integer range 0 to 10 := 0;
    signal hour0A: integer range 0 to 13 := 0;
    signal min1A: integer range 0 to 6 := 0;

begin

real_clock: process (clk_1s, min0, min1, hour0) 
begin
      if(rising_edge(clk_1s)) then
              sec <= sec + 1;
        if(sec = 60 or (btn_min0 = '1' and ALRM = '0')) then -- second > 59 then minute increases
              min0 <= min0 + 1;
              sec <= 0;
            if(min0 = 10) then -- minute > 59 then hour increases
                min1 <= min1 + 1;
                min0 <= 0; 
                if(min1 = 6) then -- hour > 24 then set hour to 0
                    hour0 <= hour0 + 1;
                    min0 <= 0;
                    min1 <= 0;
                    if (hour0 = 13) then
                        sec <=0;
                        min0 <= 0;
                        min1 <= 0;
                        hour0 <= 0;
                    end if;
                end if;
            end if;
        elsif (btn_min1 = '1' and ALRM = '0') then
                min1 <= min1 + 1;
        elsif (btn_h = '1' and ALRM = '0') then
                hour0 <= hour0 + 1;
        end if;
    end if;
end process;


alarm: process (min0A, min1A, hour0A) 
begin
    if(rising_edge(clk_1s)) then
        if (ALRM = '1') then
            if (btn_min1 = '1') then
                    min1A <= min1A + 1; 
             
             end if;
             if (btn_min0 = '1') then
                    min0A <= min0A + 1;
               end if;
            if (btn_h = '1') then
                hour0A <= hour0A + 1;
        end if;
       end if;
    end if;
end process;

anode_clk: process (count1, CLK, A_counter)
begin
    if (rising_edge(CLK)) then
        count1 <= count1 + 1;
        if (count1 = 249999) then
            A_counter <= A_counter + 1;
            count1 <= 0;
        end if;
    end if;
end process;

anode_disp: process (A_counter)
begin
AN <= tmp_AN;
if (ALRM = '0') then
    case A_counter is 
        when 0 =>
            tmp_AN <= "1110";
            if (min0 = 0) then
            Segments <= "0000001";	--0
            elsif (min0 = 1) then
            Segments <= "1001111";	--1
            elsif (min0 = 2) then
            Segments <= "0010010";	--2
            elsif (min0 = 3) then
            Segments <= "0000110";  --3
            elsif (min0 = 4) then
            Segments <= "1001100";	--4
            elsif (min0 = 5) then
            Segments <= "0100100";	--5
            elsif (min0 = 6) then
            Segments <= "0100000";	--6
            elsif (min0 = 7) then
            Segments <= "0001111";	--7
            elsif (min0 = 8) then
            Segments <= "0000000";	--8
            elsif (min0 = 9) then
            Segments <= "0000100";	--9
            end if;
        when 1 =>
            tmp_AN <= "1101";
            if (min1 = 0) then
            Segments <= "0000001";	--0
            elsif (min1 = 1) then
            Segments <= "1001111";	--1
            elsif (min1 = 2) then
            Segments <= "0010010";	--2
            elsif (min1 = 3) then
            Segments <= "0000110";  --3
            elsif (min1 = 4) then
            Segments <= "1001100";	--4
            elsif (min1 = 5) then
            Segments <= "0100100";	--5
            elsif (min1 = 6) then
            Segments <= "0000001";	--6
            end if; 
        when 2 =>
            tmp_AN <= "1011";
            if (hour0 = 0) then
            Segments <= "0000001";	--0
            elsif (hour0 = 1) then
            Segments <= "1001111";	--1
            elsif (hour0 = 2) then
            Segments <= "0010010";	--2
            elsif (hour0 = 3) then
            Segments <= "0000110";  --3
            elsif (hour0 = 4) then
            Segments <= "1001100";	--4
            elsif (hour0 = 5) then
            Segments <= "0100100";	--5
            elsif (hour0 = 6) then
            Segments <= "0100000";	--6
            elsif (hour0 = 7) then
            Segments <= "0001111";	--7
            elsif (hour0 = 8) then
            Segments <= "0000000";	--8
            elsif (hour0 = 9) then
            Segments <= "0000100";	--9
            elsif (hour0 = 10) then
            Segments <= "0000001";
            elsif (hour0 = 11) then
            Segments <= "1001111";
            elsif (hour0 = 12) then
            Segments <= "0010010";
            elsif (hour0 = 13) then
            Segments <= "0000001";
            end if; 
        when 3 =>
            tmp_AN <= "0111";
            if (hour0 = 10) then
            Segments <= "1001111";	--1
            elsif (hour0 = 11) then
            Segments <= "1001111";	--1
            elsif (hour0 = 12) then
            Segments <= "1001111";	--1
            else 
            Segments <= "0000001";
            end if;
        end case;
     
elsif (ALRM = '1') then
    case A_counter is 
        when 0 =>
            tmp_AN <= "1110";
            if (min0A = 0) then
            Segments <= "0000001";	--0
            elsif (min0A = 1) then
            Segments <= "1001111";	--1
            elsif (min0A = 2) then
            Segments <= "0010010";	--2
            elsif (min0A = 3) then
            Segments <= "0000110";  --3
            elsif (min0A = 4) then
            Segments <= "1001100";	--4
            elsif (min0A = 5) then
            Segments <= "0100100";	--5
            elsif (min0A = 6) then
            Segments <= "0100000";	--6
            elsif (min0A = 7) then
            Segments <= "0001111";	--7
            elsif (min0A = 8) then
            Segments <= "0000000";	--8
            elsif (min0A = 9) then
            Segments <= "0000100";	--9
            end if;
        when 1 =>
            tmp_AN <= "1101";
            if (min1A = 0) then
            Segments <= "0000001";	--0
            elsif (min1A = 1) then
            Segments <= "1001111";	--1
            elsif (min1A = 2) then
            Segments <= "0010010";	--2
            elsif (min1A = 3) then
            Segments <= "0000110";  --3
            elsif (min1A = 4) then
            Segments <= "1001100";	--4
            elsif (min1A = 5) then
            Segments <= "0100100";	--5
            elsif (min1A = 6) then
            Segments <= "0000001";	--6
            end if; 
        when 2 =>
            tmp_AN <= "1011";
            if (hour0A = 0) then
            Segments <= "0000001";	--0
            elsif (hour0A = 1) then
            Segments <= "1001111";	--1
            elsif (hour0A = 2) then
            Segments <= "0010010";	--2
            elsif (hour0A = 3) then
            Segments <= "0000110";  --3
            elsif (hour0A = 4) then
            Segments <= "1001100";	--4
            elsif (hour0A = 5) then
            Segments <= "0100100";	--5
            elsif (hour0A = 6) then
            Segments <= "0100000";	--6
            elsif (hour0A = 7) then
            Segments <= "0001111";	--7
            elsif (hour0A = 8) then
            Segments <= "0000000";	--8
            elsif (hour0A = 9) then
            Segments <= "0000100";	--9
            elsif (hour0A = 10) then
            Segments <= "0000001";
            elsif (hour0A = 11) then
            Segments <= "1001111";
            elsif (hour0A = 12) then
            Segments <= "0010010";
            elsif (hour0A = 13) then
            Segments <= "0000001";
            end if; 
        when 3 =>
            tmp_AN <= "0111";
            if (hour0A = 10) then
            Segments <= "1001111";	--1
            elsif (hour0A = 11) then
            Segments <= "1001111";	--1
            elsif (hour0A = 12) then
            Segments <= "1001111";	--1
            else 
            Segments <= "0000001";
            end if;
        end case;
    end if;
    
    if (hour0A = hour0) and (min0A = min0) and (min1A = min1) then
        LED <= '1';
    end if;
    
    if (RST = '1') then
        hour0A <= 0;
        end if;
end process;

end Behavioral;
