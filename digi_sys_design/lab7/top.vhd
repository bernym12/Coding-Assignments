
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top is 
   generic (N : integer := 8;
            Data: integer := 4);
   Port ( Din : in STD_LOGIC_Vector (N-1 downto 0);
          RST : in STD_LOGIC;
          CLK : in STD_LOGIC;
          Q : inout STD_LOGIC_Vector (N-1 downto 0);
          Address : in std_logic_vector(1 downto 0);
          DataIn: in std_logic_vector(Data-1 downto 0);
          DataOut: inout std_logic_vector(Data-1 downto 0);
          Segments: out std_logic_vector(N-2 downto 0));
end top;
architecture HIER of top is
    component register_counter is
        generic (N : integer := 8);
        Port ( Din : in STD_LOGIC_Vector (N-1 downto 0);
               CE : in STD_LOGIC;
               M : in STD_LOGIC_Vector (1 downto 0);
               RST : in STD_LOGIC;
               CLK : in STD_LOGIC;
               Q : out STD_LOGIC_Vector (N-1 downto 0));
    end component;
    
       

    component reg is 
    generic (N : integer := 4;
             M : integer := 2);
    Port (WE : in std_logic; --write enable
          DataIn : in std_logic_vector(N-1 downto 0); --data inputs
          Address : in std_logic_vector(M-1 downto 0); --address to read/write to
          ReadAddress: in std_logic_vector(M-1 downto 0); -- read address
          DataOut : out std_logic_vector(N-1 downto 0)); --data output
    end component;
    
    component OctalDecoder is
    generic (N : integer := 4;
             M : integer := 7);
    port (
            D        : in  STD_LOGIC_VECTOR (N-1 downto 0);
            Segments : out  STD_LOGIC_VECTOR (M-1 downto 0)
            );
    end component;
    
    component Moore_FSM_Equations_FD is
    Port ( CLK : in STD_LOGIC;--Clock
           RST : in STD_LOGIC;--Active Low synchcronus reset
           PB : in STD_LOGIC;--Active High clock enable from pushbutton
           Cout : out STD_LOGIC_VECTOR (1 downto 0);--Binary representation fo the current state
           Oout : out STD_LOGIC_VECTOR (3 downto 0));--One-cold representation fo the current state
    end component;

signal CE: STD_Logic := '1';
signal CEos: STD_Logic;
signal M: Std_logic_vector (1 downto 0) := "10";
signal WE: Std_logic;
signal Din_cnt: STD_LOGIC_VECTOR(N-1 downto 0);
signal qb: STD_LOGIC;
begin

Din_cnt <= (others => '0');
reg_count: register_counter generic map(N) port map
           (Din=>Din_cnt, CE=>CE,  M=>M, RST=>RST,  CLK=>CLK, Q=>Q);
fsm: Moore_FSM_equations_FD port map
            ( CLK=>CLK, RST=>RST, PB=>Q(N-1));
reg_file: reg port map 
            (WE=>WE, Address=>Address, DataIn=>DataIn, ReadAddress=>Q(1 downto 0), DataOut=>DataOut);
hex: OctalDecoder port map 
            (D=>DataOut, Segments=>Segments);
  
    
end architecture HIER;