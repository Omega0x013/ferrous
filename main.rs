#![no_std]
#![no_main]
#![feature(start, lang_items, asm, core_panic)]

use core::panic::PanicInfo;

// This function is called on panic.
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[lang = "eh_personality"]
extern "C" fn eh_personality() {}

#[no_mangle]
#[start]
fn main(_magic: u32, _addr: u32) {
    unsafe {
        mem::vw(0, 0x62);
    }
}

mod mem;