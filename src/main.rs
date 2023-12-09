#![no_main]
#![no_std]
#![feature(start)]
#![feature(asm_const)]

use core::panic::PanicInfo;

core::arch::global_asm!(
    include_str!("boot.s"),
    CONST_CORE_ID_MASK = const 0b11
);

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[start]
#[no_mangle]
pub fn main() -> ! {
    for c in "Hello World!".chars() {
        unsafe {
            core::ptr::write_volatile(0x3F20_1000 as *mut u8, c as u8);
        }
    }
    loop {}
}
