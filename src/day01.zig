const std = @import("std");
const builtin = @import("builtin");
const testing = std.testing;
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");

var client: util.Client = .{
    .year = 2023,
    .day = 1,
    .http_client = .{ .allocator = util.gpa },
};

pub fn main() !void {
    var input = try client.getInput();
    defer input.deinit();

    {
        var part1 = Part1{ .data = input.buffer };
        const answer = try part1.solve();
        client.submitAnswer(.{
            .part = .part1,
            .anwser = answer,
        }) catch |err| switch (err) {
            error.IncorrectAnswser => |e| return e,
            else => try testing.expectEqual(55607, answer),
        };
    }

    {
        var part2 = Part2{ .data = input.buffer };
        const answer = try part2.solve();
        client.submitAnswer(.{
            .part = .part2,
            .anwser = answer,
        }) catch |err| switch (err) {
            error.IncorrectAnswser => |e| return e,
            else => try testing.expectEqual(55291, answer),
        };
    }
}

const Part1 = struct {
    data: []const u8,

    const Input = struct {
        line: []const u8,
    };

    pub fn solve(self: *Part1) !usize {
        var answer: usize = 0;
        var it = tokenizeSca(u8, self.data, '\n');
        while (it.next()) |line| {
            answer += try self.solveSingle(.{ .line = line });
        }
        return answer;
    }

    pub fn solveSingle(self: *Part1, input: Input) !usize {
        _ = self;
        var buf: [2]u8 = undefined;
        var index: usize = 0;
        var last_char: u8 = 0;
        for (input.line) |c| {
            if (std.ascii.isDigit(c)) {
                defer index += 1;
                if (index == 0) buf[index] = c;
                last_char = c;
            }
        }
        buf[1] = last_char;
        return try parseInt(usize, &buf, 10);
    }
};

const Part2 = struct {
    data: []const u8,

    const Input = struct {
        line: []const u8,
    };

    pub fn solve(self: *Part2) !usize {
        var answer: usize = 0;
        var it = tokenizeSca(u8, self.data, '\n');
        while (it.next()) |line| {
            answer += try self.solveSingle(.{ .line = line });
        }
        return answer;
    }

    const NumMap = struct { num: []const u8, raw: u8 };

    const num_map: []const NumMap = &.{
        .{ .num = "one", .raw = '1' },
        .{ .num = "two", .raw = '2' },
        .{ .num = "three", .raw = '3' },
        .{ .num = "four", .raw = '4' },
        .{ .num = "five", .raw = '5' },
        .{ .num = "six", .raw = '6' },
        .{ .num = "seven", .raw = '7' },
        .{ .num = "eight", .raw = '8' },
        .{ .num = "nine", .raw = '9' },
    };

    pub fn solveSingle(self: *Part2, input: Input) !usize {
        _ = self;
        var buf: [2]u8 = undefined;
        var index: usize = 0;
        var last_char: u8 = 0;
        for (input.line, 0..) |c, i| {
            if (std.ascii.isDigit(c)) {
                defer index += 1;
                if (index == 0) buf[index] = c;
                last_char = c;
            } else if (getSpelledOutDigit(input.line[i..])) |n| {
                defer index += 1;
                if (index == 0) buf[index] = n;
                last_char = n;
            }
        }
        buf[1] = last_char;
        return try parseInt(usize, &buf, 10);
    }

    fn getSpelledOutDigit(data: []const u8) ?u8 {
        inline for (num_map) |num| {
            if (data.len >= num.num.len) {
                if (std.mem.eql(u8, data[0..num.num.len], num.num)) {
                    return num.raw;
                }
            }
        }
        return null;
    }
};

test "part1" {
    const data =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;
    var part1 = Part1{ .data = data };
    const answer = try part1.solve();
    try testing.expectEqual(142, answer);
}

test "part2" {
    const data =
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
    ;
    var part2 = Part2{ .data = data };
    const answer = try part2.solve();
    try testing.expectEqual(281, answer);
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
