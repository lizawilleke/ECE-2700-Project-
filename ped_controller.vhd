



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
    -- Stores the previous button value
    signal btn_previous : STD_LOGIC := '0';

begin

    
-- Detects a new button press and stores the request
process(clk, resetn)

begin

    -- Reset the stored request and previous button value
    if resetn = '0' then
        request_reg <= '0';
        btn_previous <= '0';

    elsif rising_edge(clk) then

        -- Save the current button value for the next clock
        btn_previous <= ped_btn;

        -- Clear the request when the FSM acknowledges it
        if ped_request_clear = '1' then
            request_reg <= '0';

        -- Store request only when button changes from 0 to 1
        elsif ped_btn = '1' and btn_previous = '0' then
            request_reg <= '1';

        end if;
    end if;
end process;


    -- Send stored request to main FSM
    ped_request <= request_reg;


-- Turn on WALK when the main FSM allows crossing
ped_walk <= ped_active;

-- Turn on DON'T WALK when crossing is not allowed
ped_dont_walk <= not ped_active;


-- Show remaining time when pedestrian crossing is allowed
ped_countdown <= seconds_remaining when ped_active = '1'
                 else (others => '0');


end Behavioral;
