library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg is 
    generic (N : integer := 16;
             M : integer := 4);
    Port (
          WE, CLK, rst : in std_logic; --write enable, clock, reset
          DataIn : in std_logic_vector(N-1 downto 0); --data inputs
          RA1, RA2: in std_logic_vector(M-1 downto 0); -- read address
          Address : in std_logic_vector(M-1 downto 0); --address to read/write to
          DataOut1, DataOut2 : out std_logic_vector(N-1 downto 0)); --data output
end reg;

architecture behavior of reg is
    subtype WORD is std_logic_vector(N-1 downto 0);
    type memory is array (0 to integer'(2)**M -1) of WORD;
    signal RAM: memory;
   
begin
    writing: process(WE, rst, CLK, Address, DataIn)
    variable ram_addr_in: integer range 0 to 2**M - 1; --translate addresss to integer
	variable ram_addr_read1, ram_addr_read2: integer range 0 to 2**M - 1;	
        begin
            ram_addr_in :=conv_integer(Address); --the actual conversion of the address
--            ram_addr_read1 := ;
--            ram_addr_read2 := ;
            if(rst='1') then
                RAM(0) <= x"0000";
                RAM(1) <= x"0001";
                RAM(2) <= x"0002";
                RAM(3) <= x"0003";
                RAM(4) <= x"0004";
                RAM(5) <= x"0005";
                RAM(6) <= x"0006";
                RAM(7) <= x"0007";
                RAM(8) <= x"0008";
                RAM(9) <= x"0009";
                RAM(10) <= x"0010";
                RAM(11) <= x"0011";
                RAM(12) <= x"0012";
                RAM(13) <= x"0013";
                RAM(14) <= x"0014";
                RAM(15) <= x"0015";
            elsif(rising_edge(CLK)) then
                if (WE = '1') then
                    RAM(ram_addr_in) <= DataIn;
                end if;	
            end if;  
            
        end process;
       
        DataOut1 <= RAM(conv_integer(RA1));
        DataOut2 <= RAM(conv_integer(RA2));
    
end behavior;