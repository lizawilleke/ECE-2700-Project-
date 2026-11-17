----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2026 06:14:47 PM
-- Design Name: 
-- Module Name: mode_controller - Behavioral
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


entity mode_controller is
    Port ( clk : in STD_LOGIC;
           resetn : in STD_LOGIC;
           sw_night : in STD_LOGIC;
           night_mode : out STD_LOGIC);
end mode_controller;

architecture Behavioral of mode_controller is
signal s1, s2 : std_logic := '0';


begin
    process(clk)
    begin 
     if rising_edge(clk) then
      if resetn = '0' then s1 <= '0'; s2 <= '0';
      else s1 <= sw_night; s2 <= s1;
      end if;
    end if;
  end process;
  night_mode <= s2;



end Behavioral;
