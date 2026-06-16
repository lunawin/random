/* written at 17/06/2026, 01:20 AM */
use std::alloc::{alloc, dealloc, Layout};

struct ArenaAllocator {
    memory: *mut u8,
    capacity: usize,
    current_off: usize
}

impl ArenaAllocator {
    pub fn new(memory: *mut u8, capacity: usize) -> Self {
        Self {
            memory,
            capacity,
            current_off: 0
        }
    }

    pub unsafe fn alloc(&mut self, size: usize, align: usize) -> Option<*mut u8> {
        let off = self.current_off + (align - self.current_off % align) % align;
        
        if self.capacity < (off + size) {
            return None;
        }
        
        unsafe {
            let mem = self.memory.add(off);
            self.current_off = off + size;
            Some(mem)
        }
    }

    pub fn reset(&mut self) {
        self.current_off = 0;
    }
}


fn main() {
    unsafe {
        let layout = Layout::from_size_align(11, 1).unwrap();
        let mem = alloc(layout);

        let mut arena = ArenaAllocator::new(mem, layout.size());

        let mem1 = arena.alloc(2, 1).unwrap();
        let mem2 = arena.alloc(3, 4).unwrap();
        let mem3 = arena.alloc(3, 2).unwrap();

        println!("{:?}", mem1);
        println!("{:?}", mem2);
        println!("{:?}", mem3);

        arena.reset();
        dealloc(mem, layout);
    }
}
