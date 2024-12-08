const std = @import("std");
const root = @import("root.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    defer _ = gpa.deinit();

    const list_one, const list_two = try root.parse_lists(allocator);

    defer list_one.deinit();
    defer list_two.deinit();

    var total_difference: u32 = 0;

    for (0..list_one.items.len) |index| {
        const value_one = list_one.items[index];
        const value_two = list_two.items[index];

        const abs_difference: u32 = @abs(value_one - value_two);

        total_difference += abs_difference;
    }

    const stdout = std.io.getStdOut().writer();

    try stdout.print("{d}\n", .{total_difference});
}
