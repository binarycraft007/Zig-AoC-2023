const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day01.txt");

pub fn main() !void {
    const sum = try getCalibrationSum(data);
    print("sum={}\n", .{sum});
}

fn getCalibrationValue(line: []const u8) !usize {
    var index: usize = 0;
    var first: u8 = 0;
    var number: [2]u8 = undefined;
    for (line) |c| {
        if (std.ascii.isDigit(c)) {
            if (index == 0) first = c;
            number[1] = c;
            index += 1;
        }
    }
    number[0] = first;
    if (index == 0) return error.NotFound;
    if (index == 1) number[index] = first;
    return try parseInt(usize, &number, 10);
}

fn getCalibrationSum(doc: []const u8) !usize {
    var sum: usize = 0;
    var stream = std.io.fixedBufferStream(doc);
    while (true) {
        var buf: [1024]u8 = undefined;
        const line_maybe = try stream.reader().readUntilDelimiterOrEof(&buf, '\n');
        if (line_maybe) |line| {
            const value = try getCalibrationValue(line);
            sum += value;
        } else {
            break;
        }
    }
    return sum;
}

test "part1 example" {
    const doc =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;
    const sum = try getCalibrationSum(doc);
    try std.testing.expect(sum == 142);
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
