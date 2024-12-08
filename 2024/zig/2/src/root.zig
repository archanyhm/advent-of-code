const std = @import("std");
const testing = std.testing;

pub fn LineIterator(comptime BufferSize: usize) type {
    return struct {
        buffered_reader: std.io.BufferedReader(BufferSize, std.fs.File.Reader),
        buffer: [BufferSize]u8 = undefined,
        allocator: std.mem.Allocator,

        const Self = @This();

        pub fn init(file: std.fs.File, allocator: std.mem.Allocator) Self {
            return Self{
                .buffered_reader = std.io.bufferedReaderSize(BufferSize, file.reader()),
                .allocator = allocator,
            };
        }

        pub fn next(self: *Self) !?[]u8 {
            return self.buffered_reader.reader().readUntilDelimiterOrEofAlloc(
                self.allocator, 
                '\n', 
                BufferSize
            );
        }

        pub fn deinit(self: *Self) void {
            _ = self;
        }
    };
}

pub fn check_subslices(excluded_index: ?usize, line: []u8) !?usize {
    var iter = std.mem.splitSequence(u8, line, " ");

    var decreasing: ?bool = null;
    var last_value: ?i32 = null;
    var i: usize = 0;

    while (iter.next()) |value| {
        if (excluded_index != null and excluded_index.? == i) {
            i += 1;
            continue;
        }

        const parsed_num = try std.fmt.parseInt(i32, value, 10);

        if (last_value == null) {
            last_value = parsed_num;
            i += 1;
            continue;
        }

        if (decreasing == null) {
            decreasing = last_value.? > parsed_num;
        } else if (decreasing == true and last_value.? < parsed_num) {
            return i;
        } else if (decreasing == false and last_value.? > parsed_num) {
            return i;
        } else if (last_value.? == parsed_num) {
            return i;
        }

        const diff = @abs(last_value.? - parsed_num);

        if (diff > 3 or diff < 1) {
            return i;
        }

        last_value = parsed_num;
        i += 1;
    }

    return null;
}