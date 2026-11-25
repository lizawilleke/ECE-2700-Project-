----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2026 09:12:56 AM
-- Design Name: 
-- Module Name: timing_controller - Behavioral
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

entity timing_controller is
    Generic ( CLK_FREQ      : positive := 100_000_000;  -- Nexys clock in Hz
              DURATION_BITS : positive := 8;            -- 8 bits = up to 255 seconds
              FLASH_FREQ_HZ : positive := 1 );          -- blinks per second at night
    Port ( clk               : in  STD_LOGIC;
           resetn            : in  STD_LOGIC;           -- active-low reset
           timer_start       : in  STD_LOGIC;
           timer_duration    : in  UNSIGNED(DURATION_BITS-1 downto 0);  -- seconds
           timer_done        : out STD_LOGIC;
           seconds_remaining : out UNSIGNED(DURATION_BITS-1 downto 0);
           flash_enable      : out STD_LOGIC );         -- free-running blink signal
end timing_controller;

architecture Behavioral of timing_controller is

    type state_type is (S_IDLE, S_RUNNING, S_DONE);
    signal state : state_type := S_IDLE;

    -- Counts clock cycles to make a 1-second tick
    signal tick_count : integer range 0 to CLK_FREQ-1 := 0;

    -- Internal copy of the seconds left (output ports can't be read in older VHDL)
    signal remaining_count : unsigned(DURATION_BITS-1 downto 0) := (others => '0');

    -- Clock cycles for half of one blink (on for half, off for half)
    constant HALF_PERIOD_CYCLES : positive := CLK_FREQ / (2 * FLASH_FREQ_HZ);

    signal flash_count : integer range 0 to HALF_PERIOD_CYCLES-1 := 0;
    signal flash_reg   : std_logic := '0';

begin

    -- Countdown timer
    process(clk)
    begin
        if rising_edge(clk) then
            if resetn = '0' then
                state           <= S_IDLE;
                tick_count      <= 0;
                remaining_count <= (others => '0');
            else
                case state is

                    -- S_IDLE and S_DONE have identical next-state rules
                    when S_IDLE | S_DONE =>
                        if timer_start = '0' then
                            state <= S_IDLE;
                        elsif timer_duration = 0 then        -- start = 1, duration = 0
                            state <= S_DONE;
                        else                                 -- start = 1, duration /= 0
                            state           <= S_RUNNING;
                            remaining_count <= timer_duration;  -- load the countdown
                            tick_count      <= 0;               -- restart the 1 s tick
                        end if;

                    when S_RUNNING =>
                        if tick_count = CLK_FREQ-1 then      -- 1 second has passed
                            tick_count <= 0;
                            if remaining_count = 1 then
                                state           <= S_DONE;
                                remaining_count <= (others => '0');
                            else
                                remaining_count <= remaining_count - 1;  -- stay in S_RUNNING
                            end if;
                        else
                            tick_count <= tick_count + 1;
                        end if;

                end case;
            end if;
        end if;
    end process;

    -- Free-running flash generator: toggles flash_reg every half period.
    -- The FSM decides when to use it (only while in S_NIGHT).
    process(clk)
    begin
        if rising_edge(clk) then
            if resetn = '0' then
                flash_count <= 0;
                flash_reg   <= '0';
            elsif flash_count = HALF_PERIOD_CYCLES-1 then
                flash_count <= 0;
                flash_reg   <= not flash_reg;
            else
                flash_count <= flash_count + 1;
            end if;
        end if;
    end process;

    -- Moore output: depends only on the state
    timer_done        <= '1' when state = S_DONE else '0';
    seconds_remaining <= remaining_count;
    flash_enable      <= flash_reg;

end Behavioral;
