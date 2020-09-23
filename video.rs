// Write QWORD
pub unsafe fn wq(addr: u32, qword: u32) {
	*(addr as *mut u32) = qword;
}

// Write WORD
pub unsafe fn ww(addr: u32, word: u16) {
	*(addr as *mut u16) = word;
}

// Write BYTE
pub unsafe fn wb(addr: u32, byte: u8) {
	*(addr as *mut u8) = byte;
}

// Video Offset
pub fn voff(cursor: u32) -> u32 {
	VIDEO_BASE + cursor*2
}

pub fn putc(cursor: u32, c: u8) {
	unsafe{
		*(voff(cursor) as *mut u16) = (0x0F00 as u16) | (c as u16);
	}
}

pub const VIDEO_BASE: u32 = 0xB8000;