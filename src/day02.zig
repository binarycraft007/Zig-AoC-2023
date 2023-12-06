const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day02.txt");

pub fn main() !void {
    const sum = try CubeSet.getIdSumByConstraint(data, .{ .red = 12, .green = 13, .blue = 14 });
    print("sum={}\n", .{sum});
}

const CubeSet = struct {
    id: usize,
    cubes: Cubes = .{},

    const Cubes = struct {
        red: usize = 0,
        green: usize = 0,
        blue: usize = 0,
    };

    fn getRecord(cube: []const u8, cubes: *Cubes) !void {
        inline for (@typeInfo(@TypeOf(cubes.*)).Struct.fields) |field| {
            if (std.mem.endsWith(u8, cube, field.name)) {
                const num = try parseInt(u8, trim(u8, cube, " " ++ field.name), 10);
                if (@field(cubes, field.name) < num) @field(cubes, field.name) = num;
                return;
            }
        }
        return error.NotFound;
    }

    pub fn getRequiredCubeSet(line: []const u8) !CubeSet {
        var it_colon = splitAny(u8, line, ":");
        const id = trim(u8, it_colon.first(), "Game ");
        var cube_set: CubeSet = .{ .id = try parseInt(u8, id, 10) };
        var it_semicolon = splitAny(u8, it_colon.rest(), ";");
        while (it_semicolon.next()) |set| {
            var it_comma = splitAny(u8, set, ",");
            while (it_comma.next()) |cube| {
                try getRecord(cube, &cube_set.cubes);
            }
        }
        return cube_set;
    }

    pub fn getIdSumByConstraint(doc: []const u8, constraint: Cubes) !usize {
        var sum: usize = 0;
        var stream = std.io.fixedBufferStream(doc);
        while (true) {
            var buf: [4096]u8 = undefined;
            const line_maybe = try stream.reader().readUntilDelimiterOrEof(&buf, '\n');
            if (line_maybe) |line| {
                var satisfied = true;
                const cube_set = try getRequiredCubeSet(line);
                inline for (@typeInfo(@TypeOf(constraint)).Struct.fields) |field| {
                    if (@field(cube_set.cubes, field.name) > @field(constraint, field.name)) {
                        satisfied = false;
                        break;
                    }
                }
                if (satisfied) sum += cube_set.id;
            } else {
                break;
            }
        }
        return sum;
    }
};

test "part1 example" {
    const doc =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;
    const sum = try CubeSet.getIdSumByConstraint(doc, .{ .red = 12, .green = 13, .blue = 14 });
    try std.testing.expect(sum == 8);
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
