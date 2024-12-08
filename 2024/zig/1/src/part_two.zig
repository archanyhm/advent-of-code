const std = @import("std");
const root = @import("root.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    defer _ = gpa.deinit();

    const list_one, const list_two = try root.parse_lists(allocator);
    
    defer list_one.deinit();
    defer list_two.deinit();

    var list_two_hashmap = std.AutoHashMap(i32, i32).init(allocator);
    defer list_two_hashmap.deinit();

    for (list_two.items) |element| {
        const value_ptr = list_two_hashmap.getPtr(element);

        if (value_ptr) |value| {
            value.* += 1;
        } else {
            try list_two_hashmap.put(element, 1);
        }
    }

    var similarity_score: i32 = 0;

    for (list_one.items) |element| {
        const entry = list_two_hashmap.get(element);

        const occurrences = entry orelse 0;

        const element_similiarity_score = element * occurrences;
        similarity_score += element_similiarity_score;
    }

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{similarity_score});
}