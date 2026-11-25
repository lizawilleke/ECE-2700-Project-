library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Top-Level: Four-Way Traffic Light Controller (Nexys A7)
-- Connects mode_controller, timing_controller, ped_system and traffic_fsm.

entity traffic_top is
    Generic ( CLK_FREQ : positive := 100_000_000 );  -- leave default on hardware
    Port (
        clk           : in  STD_LOGIC;   -- 100 MHz board clock
        resetn        : in  STD_LOGIC;   -- CPU_RESETN button (active low)
        sw_night      : in  STD_LOGIC;   -- SW0: 1 = night mode
        btn_ped       : in  STD_LOGIC;   -- BTNC: pedestrian button

        -- Vehicle lights
        ns_red        : out STD_LOGIC;
        ns_yellow     : out STD_LOGIC;
        ns_green      : out STD_LOGIC;
        ew_red        : out STD_LOGIC;
        ew_yellow     : out STD_LOGIC;
        ew_green      : out STD_LOGIC;

        -- Pedestrian signals
        ped_walk      : out STD_LOGIC;
        ped_dont_walk : out STD_LOGIC;
        ped_countdown : out unsigned(5 downto 0)
    );
end traffic_top;

architecture Structural of traffic_top is

    constant DURATION_BITS : positive := 16;  -- matches traffic_fsm timer_duration

    -- mode_controller -> traffic_fsm
    signal night_mode        : std_logic;

    -- traffic_fsm <-> timing_controller
    signal timer_start       : std_logic;
    signal timer_duration    : unsigned(DURATION_BITS-1 downto 0);
    signal timer_done        : std_logic;
    signal seconds_remaining : unsigned(DURATION_BITS-1 downto 0);
    signal flash_enable      : std_logic;

    -- traffic_fsm <-> ped_system
    signal ped_request       : std_logic;
    signal ped_active        : std_logic;
    signal ped_request_clear : std_logic;

begin

    mode_inst : entity work.mode_controller
        port map (
            clk        => clk,
            resetn     => resetn,
            sw_night   => sw_night,
            night_mode => night_mode
        );

    timing_inst : entity work.timing_controller
        generic map (
            CLK_FREQ      => CLK_FREQ,
            DURATION_BITS => DURATION_BITS
        )
        port map (
            clk               => clk,
            resetn            => resetn,
            timer_start       => timer_start,
            timer_duration    => timer_duration,
            timer_done        => timer_done,
            seconds_remaining => seconds_remaining,
            flash_enable      => flash_enable
        );

    ped_inst : entity work.ped_system
        port map (
            clk               => clk,
            resetn            => resetn,
            ped_btn           => btn_ped,
            night_mode        => night_mode,
            ped_active        => ped_active,
            ped_request_clear => ped_request_clear,
            seconds_remaining => seconds_remaining(5 downto 0),  -- 6-bit slice
            ped_request       => ped_request,
            ped_walk          => ped_walk,
            ped_dont_walk     => ped_dont_walk,
            ped_countdown     => ped_countdown
        );

    fsm_inst : entity work.traffic_fsm
        generic map (
            GREEN_TIME_SEC  => 8,   -- shortened for demo (default 30)
            YELLOW_TIME_SEC => 3    -- shortened for demo (default 5)
        )
        port map (
            clk               => clk,
            resetn            => resetn,
            night_mode        => night_mode,
            ped_request       => ped_request,
            timer_done        => timer_done,
            flash_enable      => flash_enable,
            timer_start       => timer_start,
            timer_duration    => timer_duration,
            ped_active        => ped_active,
            ped_request_clear => ped_request_clear,
            ns_red            => ns_red,
            ns_yellow         => ns_yellow,
            ns_green          => ns_green,
            ew_red            => ew_red,
            ew_yellow         => ew_yellow,
            ew_green          => ew_green
        );

end Structural;
