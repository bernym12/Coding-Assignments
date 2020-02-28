library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg is 
    generic (N : integer := 4;
             M : integer := 2);
    Port (WE : in std_logic; --write enable
          DataIn : in std_logic_vector(N-1 downto 0); --data inputs
          ReadAddress: in std_logic_vector(M-1 downto 0); -- read address
          Address : in std_logic_vector(M-1 downto 0); --address to read/write to
          DataOut : out std_logic_vector(N-1 downto 0)); --data output
end reg;

architecture behavior of reg is
    subtype WORD is std_logic_vector(N-1 downto 0);
    type memory is array (0 to 2**M -1) of WORD;
    signal RAM: memory;
   
begin
    writing: process(WE, Address, DataIn, ReadAddress)
    variable ram_addr_in: integer range 0 to 2**M - 1; --translate addresss to integer
	variable ram_addr_read: integer range 0 to 2**M - 1;	
		begin
            ram_addr_in :=conv_integer(Address); --the actual conversion of the address
            ram_addr_read := conv_integer(ReadAddress);
            if rising_edge(WE) then
                RAM(ram_addr_in) <= DataIn;
            end if;	  
   			DataOut <= RAM(ram_addr_read);
    end process;
    
end behavior;