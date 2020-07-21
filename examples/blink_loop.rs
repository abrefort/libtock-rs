#![no_std]

use core::cell::Cell;
use libtock::buttons::ButtonState;
use libtock::result::TockResult;
use libtock::timer::Duration;

#[libtock::main]
async fn main() -> TockResult<()> {
    let mut drivers = libtock::retrieve_drivers()?;

    let buttons_driver = drivers.buttons.init_driver()?;
    let leds_driver = drivers.leds.init_driver()?;
    let mut timer_driver = drivers.timer.create_timer_driver();
    let timer_driver = timer_driver.activate()?;

    let led_map = [0, 1, 3, 2];

    let speed = Cell::new(1usize);

    let mut callback = |button_num, state| {
        if let (ButtonState::Pressed, 0) = (state, button_num) {
            // TODO : Data race ?
            if speed.get() > 1 {
                speed.set(speed.get() - 1);
            }
        } else if let (ButtonState::Pressed, 1) = (state, button_num) {
            // TODO : Data race ?
            if speed.get() < 20 {
                speed.set(speed.get() + 1);
            }
        }
    };

    let _subscription = buttons_driver.subscribe(&mut callback)?;
    for button in buttons_driver.buttons() {
        button.enable_interrupt()?;
    }

    loop {
        for led in &led_map {
            let led = leds_driver.get(*led).ok().unwrap();
            led.on()?;
            timer_driver
                .sleep(Duration::from_ms(100 * speed.get()))
                .await?;
            led.off()?;
        }
    }
}
