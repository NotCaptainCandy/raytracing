const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const gpa = init.gpa;
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.createFile(io, "image.ppm", .{});
    defer file.close(io);

    const IMAGE_WIDTH = 256;
    const IMAGE_HEIGHT = 256;

    const write_buffer = try gpa.alloc(u8, IMAGE_HEIGHT * IMAGE_WIDTH);
    defer gpa.free(write_buffer);

    var file_writer = file.writer(io, write_buffer);
    const fw = &file_writer.interface;

    try fw.print("P3\n{} {}\n255\n", .{ IMAGE_WIDTH, IMAGE_HEIGHT });
    try fw.flush();

    var i: u16 = 0;
    var j: u16 = 0;

    while (i < IMAGE_HEIGHT) : (i += 1) {
        while (j < IMAGE_WIDTH) : (j += 1) {
            try fw.print("{} 0 {}\n", .{ j, i });
        }
        j = 0;
    }
    try fw.flush();
}
