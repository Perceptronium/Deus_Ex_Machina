---------------------------
-- Author : Perceptronium
-- Date : 19-11-2020
---------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Blinky_LED is -- This is our LED entity, it takes the CLK as input
    port(
            CLK : in std_logic;
            LED : out std_logic
        );
end Blinky_LED;

architecture archi of Blinky_LED is
    constant CLK_FRQ : natural := 500e6; -- Let's consider a 500 MHz clock
begin

blinking: process(CLK)
    variable Ctr : natural range 0 to CLK_FRQ;
    variable Cycle : natural range 0 to 2;
    variable State : natural range 0 to 1;
    begin
        if rising_edge(CLK) then -- Synchrone mechanism
            if Ctr = CLK_FRQ then -- If a second has elapsed
                Cycle := Cycle + 1; -- Iterate Cycle
                    if Cycle = 2 then -- If it's been 2 seconds
                        if State = 0 then -- If the LED was turned off
                            LED <= '1'; -- Turn on the LED
                            State := 1;
                        else            -- If it was turned on
                            LED <= '0'; -- Turn it off
                            State := 0;
                        Cycle := 0;
                        end if;
                    end if;
            else
                Ctr := Ctr + 1;
            end if;
        end if;
    end process;        
end archi;
