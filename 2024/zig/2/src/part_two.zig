const std = @import("std");
const root = @import("root.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    defer _ = gpa.deinit();

    const file = try std.fs.cwd().openFile("resources/input.file", .{ .mode = .read_only });
    defer file.close();

    var line_iterator = root.LineIterator(1024).init(file, allocator);
    defer line_iterator.deinit();

    var safe_reports: i32 = 0;
    while (try line_iterator.next()) |line| {
        defer allocator.free(line);

        const error_index = try root.check_subslices(null, line);

        if (error_index) |index| {
            var i = index;
            while (true) {
                const inner_error_index = try root.check_subslices(i, line);

                if (inner_error_index == null) {
                    safe_reports += 1;
                    break;
                }

                if (i <= 0) {
                    break;
                } else {
                    i -= 1;
                }
            }
        } else {
            safe_reports += 1;
        }
    }

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}", .{safe_reports});
}
