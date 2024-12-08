const std = @import("std");
const testing = std.testing;

pub fn parse_lists(allocator: std.mem.Allocator) !struct { std.ArrayList(i32), std.ArrayList(i32) } {
    const file_path = "resources/input.file";

    var file = try std.fs.cwd().openFile(file_path, .{ .mode = .read_only });
    defer file.close();
    var buffered_reader = std.io.bufferedReader(file.reader());
    var reader = buffered_reader.reader();

    var list_one = std.ArrayList(i32).init(allocator);
    var list_two = std.ArrayList(i32).init(allocator);

    while (true) {
        const line = try reader.readUntilDelimiterOrEofAlloc(allocator, '\n', 1024);
        if (line == null) break;

        const nonopt_line = line orelse unreachable;
        defer allocator.free(nonopt_line);

        const sanitized_line = std.mem.trimRight(u8, nonopt_line, "\r\n");

        var splits = std.mem.splitSequence(u8, sanitized_line, "   ");

        const chunk_1 = splits.next() orelse "";
        const chunk_2 = splits.next() orelse "";

        const number_1 = try std.fmt.parseInt(i32, chunk_1, 10);
        const number_2 = try std.fmt.parseInt(i32, chunk_2, 10);

        try list_one.append(number_1);
        try list_two.append(number_2);
    }

    std.mem.sort(i32, list_one.items, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, list_two.items, {}, comptime std.sort.asc(i32));

    return .{ list_one, list_two };
}
