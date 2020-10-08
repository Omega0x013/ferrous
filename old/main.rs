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
    	clear_video();
        // putc(0x61, 0);
        *(0xb8000 as *mut u8) = 0x61;
    }
}

mod mem;

#[allow(dead_code)]
extern "C" {
    fn putc(character: u8, offset: u32);
	fn clear_video();
}
