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
        // *(0xB8000 as *mut u16) = 0x0F61;
        // video::putc(0, 61, 07);
        // video::ww(0xb8000, 0x0F61);
        // video::wb(0xb8000 + 2, 0x61);
        // video::wb(0xb8000 + 3, 0x0F);
        // video::wq(0xb8000 + 4, 0x0F690F68);
        // video::ww(video::VIDEO_BASE + 8, 0x0F60);
        // video::ww(video::voff(5), 0x0F62);
        // video::putc(6, 0x63);
        // video::putc(7, 0x64);
        video::putc(0, 0x61);
        // video::ww(0xB8000, 0x0FFF);
    }
}

// video memory location, making sure the compiler knows it's reserved
static mut VIDEO: *mut [u16; 0x7d0] = 0xB8000 as *mut[u16; 0x7d0];
mod video;