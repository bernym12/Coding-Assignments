----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/30/2019 02:39:22 PM
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity digital_clk is
    Port( CLK: in std_logic;
          btn_min0, btn_min1, btn_hour: in std_logic;
          AN: out std_logic_vector (3 downto 0);
          Segments: out std_logic_vector (6 downto 0);
          LED: out std_logic;
          RST: in std_logic;
          ALRM: in std_logic
        );
end digital_clk;

architecture Behavioral of digital_clk is 
    component counter is
    Port(
        CLK: in std_logic;
        clk_1s: out std_logic
        );
    end component;

    component clock_logic is
    Port (CLK: in std_logic;
          clk_1s: in std_logic;
          btn_min0, btn_min1, btn_h: in std_logic;
          AN: out std_logic_vector(3 downto 0);
          Segments: out std_logic_vector(6 downto 0);
          ALRM: in std_logic;
          LED: out std_logic;
          RST: in std_logic
    );
end component;

signal clk_1s: std_logic;

begin 
    clk_secs: counter port map
        (CLK => CLK, clk_1s => clk_1s);
    time: clock_logic port map 
        (CLK => CLK, clk_1s => clk_1s, btn_min0=>btn_min0, btn_min1=>btn_min1, btn_h=>btn_hour, AN=>AN, Segments => Segments, ALRM => ALRM, RST=> RST, LED => LED);

end Behavioral;
