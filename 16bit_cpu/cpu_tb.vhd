library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cpu_tb is
end entity cpu_tb;

architecture behavior of cpu_tb is
    component top IS
    PORT (
        CLK, rst : IN std_logic;
        inr: in std_logic_vector(3 downto 0);
        outvalue: out std_logic_vector(15 downto 0)
    );
    END component;
    signal clk, rst: std_logic := '0';
    signal outvalue: std_logic_vector(15 downto 0);
    constant clk_period: time := 5 ns; 
begin
    
    cpu: top port map (
        CLK => clk,
        rst => rst,
        inr => "1001",
        outvalue => outvalue
    );

    clk_proc: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process clk_proc;
    
full_proc: process
    begin      
        rst <= '1';
        wait for clk_period/10;
        rst <= '0';
        wait for clk_period*400;
        wait;
    end process full_proc;
end architecture behavior;