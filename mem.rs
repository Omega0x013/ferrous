// Write DWORD
#[allow(dead_code)]
pub unsafe fn wd(addr: u32, qword: u32) {
	*(addr as *mut u32) = qword;
}

// Write WORD
#[allow(dead_code)]
pub unsafe fn ww(addr: u32, word: u16) {
	*(addr as *mut u16) = word;
}

// Write BYTE
#[allow(dead_code)]
pub unsafe fn wb(addr: u32, byte: u8) {
	*(addr as *mut u8) = byte;
}

// Read DWORD
#[allow(dead_code)]
pub unsafe fn rd(addr: u32) -> u32 {
	let data: u32 = *(addr as *mut u32);
	return data
}

// Read WORD
#[allow(dead_code)]
pub unsafe fn rw(addr: u32) -> u16 {
	let data: u16 = *(addr as *mut u16);
	return data
}

// Read BYTE
#[allow(dead_code)]
pub unsafe fn rb(addr: u32) -> u8 {
	let data: u8 = *(addr as *mut u8);
	return data
}

// Write CHAR
#[allow(dead_code)]
pub unsafe fn vw(offset: u32, c: u8) {
	ww(0xb8000 + offset as u32, ((0x07 as u16) << 8) | (c as u16));
}