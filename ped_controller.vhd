
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Pedestrian Crossing Controller
-- This module detects when the pedestrian button is pressed
-- and sends a request to the main traffic light FSM.
-- Pedestrian requests are accepted during day and night.

entity ped_controller is
    Port (
        clk               : in STD_LOGIC;  -- Clock
        resetn            : in STD_LOGIC;  -- Reset (active low)
        ped_btn           : in STD_LOGIC;  -- Pedestrian button
        night_mode        : in STD_LOGIC;  -- 1 = night, 0 = day
        ped_active        : in STD_LOGIC;  -- Crossing allowed by FSM
        ped_request_clear : in STD_LOGIC;  -- Clears pedestrian request
        seconds_remaining : in unsigned(5 downto 0); -- Timer value

        ped_request       : out STD_LOGIC; -- Request sent to FSM
        ped_walk          : out STD_LOGIC; -- WALK light
        ped_dont_walk     : out STD_LOGIC; -- DON'T WALK light
        ped_countdown     : out unsigned(5 downto 0) -- Countdown
    );
end ped_controller;

architecture Behavioral of ped_controller is

    -- Stores the pedestrian request
    signal request_reg : STD_LOGIC := '0';

begin

    -- Checks for a button press on each clock cycle
    process(clk, resetn)
    begin

        -- Clear request when reset is pressed
        if resetn = '0' then
            request_reg <= '0';

        elsif rising_edge(clk) then

            -- Clear request when FSM acknowledges it
            if ped_request_clear = '1' then
                request_reg <= '0';

            -- Store button press during day or night
            elsif ped_btn = '1' then
                request_reg <= '1';

            end if;
        end if;
    end process;

    -- Send stored request to main FSM
    ped_request <= request_reg;

    -- Temporary outputs until WALK logic is added
    ped_walk <= '0';
    ped_dont_walk <= '1';
    ped_countdown <= (others => '0');

end Behavioral;
