const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day03.txt");

pub fn main() !void {
    const part1_sum = try getPartNumberSum(data);
    std.debug.print("part1 sum {d}\n", .{part1_sum});
}

fn getIndex(x: usize, y: usize, line_size: usize) usize {
    return x + y * (line_size + 1);
}

fn getPartNumberSum(doc: []const u8) !usize {
    var y: usize = 0;
    var sum: usize = 0;
    var stream = std.io.fixedBufferStream(doc);
    while (true) {
        var buf: [4096]u8 = undefined;
        const line_maybe = try stream.reader().readUntilDelimiterOrEof(&buf, '\n');
        if (line_maybe) |line| {
            defer y += 1;
            var x: usize = 0;
            while (x < line.len) : (x += 1) {
                var parser = std.fmt.Parser{ .buf = doc[getIndex(x, y, line.len)..] };
                const number = parser.number() orelse continue;
                const number_size = std.math.log10(number) + 1;
                defer x += number_size - 1;
                const pre_start = if (x == 0) x else x - 1;
                const post_start = if (x + number_size == line.len) x + number_size else x + number_size + 1;
                const pre_line = if (y == 0) y else y - 1;
                const post_line = if (y + 1 == line.len) y else y + 1;
                for (pre_line..post_line + 1) |check_y| {
                    for (pre_start..post_start) |check_x| {
                        switch (doc[getIndex(check_x, check_y, line.len)]) {
                            '0'...'9', '.' => {},
                            else => {
                                sum += number;
                            },
                        }
                    }
                }
            }
        } else {
            break;
        }
    }
    return sum;
}

test "part1 example" {
    const doc =
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
    ;
    const sum = try getPartNumberSum(doc);
    try std.testing.expect(sum == 4361);
}

// Useful stdlib functions
const tokenizeAny = std.mem.tokenizeAny;
const tokenizeSeq = std.mem.tokenizeSequence;
const tokenizeSca = std.mem.tokenizeScalar;
const splitAny = std.mem.splitAny;
const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.block;
const asc = std.sort.asc;
const desc = std.sort.desc;

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
