library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity register_tb is 	 
	 generic (N : integer := 4;
	 M : integer := 2;
	 T: time := 25 ns  );  
end register_tb;

architecture test of register_tb is	  

    component reg is
        generic (N : integer := 3;
                M : integer := 3);  
        Port (
          WE : in std_logic; --write enable
          DataIn : in std_logic_vector(N-1 downto 0); --data inputs
          Address : in std_logic_vector(M-1 downto 0); --address to write to/read from
          DataOut : out std_logic_vector(N-1 downto 0)); --data output
    end component;
signal WE : std_logic := '0'; --write enable
signal DataIn : std_logic_vector(N-1 downto 0); --data inputs
signal Address : std_logic_vector(M-1 downto 0); --address to write to/read from
signal DataOut : std_logic_vector(N-1 downto 0); --data output
    
begin
    REG1: reg generic map(N, M) port map(WE, DataIn, Address, DataOut); --hierarchical connection to register file
	process begin 
		 WE <= '1';
    for w in 0 to (2**M - 1) loop  -- Write address as data
	   	  	Address <= std_logic_vector(to_unsigned(w, M));	
		  	DataIn <= std_logic_vector(to_unsigned(w, N));
			WE <= '0';
			wait for T ;
			WE <='1' ;
			wait for T  ;	
	end loop;
        
    for r in 0 to (2**M - 1) loop  -- read address, write inverted address as data
        Address <= std_logic_vector(to_unsigned(r, M));
        DataIn <= not std_logic_vector(to_unsigned(r, N));
        WE <= '0';
        wait for T  ;
        WE <='1' ;
        wait for T  ;    	
     end loop;

    for ri in (2**M - 1) downto 0 loop -- read inverted address, write address as data
		 Address <= not std_logic_vector(to_unsigned(ri, M));
           DataIn <= std_logic_vector(to_unsigned(ri, N));
           WE <= '0';
           wait for T  ;
           WE <='1' ;
           wait for T  ;    
	end loop;

    for ra in 0 to (2**M -1) loop  --read address
		Address <= std_logic_vector(to_unsigned(ra, M));
	end loop;

   end process;
end test;