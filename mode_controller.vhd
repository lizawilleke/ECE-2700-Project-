----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2026 09:12:56 AM
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
use IEEE.NUMERIC_STD.ALL;

entity mode_controller is
    Port ( clk        : in  STD_LOGIC;
           resetn     : in  STD_LOGIC;                  -- active-low reset
           sw_night   : in  STD_LOGIC;                  -- manual day/night switch
           night_mode : out STD_LOGIC );                -- 1 = night, 0 = day
end mode_controller;

architecture Behavioral of mode_controller is

    -- Two-stage synchronizer for the asynchronous switch input
    signal sw_sync   : std_logic_vector(1 downto 0) := "00";
    signal night_reg : std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if resetn = '0' then
                sw_sync   <= "00";
                night_reg <= '0';
            else
                sw_sync   <= sw_sync(0) & sw_night;
                night_reg <= sw_sync(1);
            end if;
        end if;
    end process;

    night_mode <= night_reg;

end Behavioral;

