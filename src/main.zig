const std = @import("std");

const clap = @import("clap");
const fs = @import("files.zig");

var threaded: std.Io.Threaded = .init_single_threaded;
const io = threaded.io();

const params_desc: []const u8 = blk: {
    break :blk 
    \\-h, --help          Usage: ls [OPTIONS: -l -a] [Directory]
    \\-l, --long          List files in the long format.
    \\-a, --a             Include directory entries whose names begin with a dot (‘.’).
    \\-s, --sort <u8>     Sort results. Options: 0-name(asc, Default) 1-name length(asc).
    \\<str>...
    \\
    ;
};

pub fn main(init: std.process.Init) !void {
    const allocator = std.heap.page_allocator;

    // parse command line arguments
    const params = comptime clap.parseParamsComptime(params_desc);
    var res = try clap.parse(
        clap.Help,
        &params,
        clap.parsers.default,
        init.minimal.args,
        .{
            .allocator = allocator,
        },
    );

    var show_hidden: bool = false;
    var show_detail: bool = false;
    var sort_type: u8 = 0;
    var path: []const u8 = ".";

    // process parsed args
    if (res.args.help != 0) {
        // show hellp msg
        std.debug.print("{s}\n", .{params_desc});
        return;
    }
    if (res.args.long != 0) {
        // set long listing mode
        show_detail = true;
    }
    if (res.args.a != 0) {
        // show hidden files
        show_hidden = true;
    }
    // set sort type
    if (res.args.sort) |sort| {
        sort_type = sort;
    }

    // get file path from args
    if (res.positionals[0].len > 0) {
        path = res.positionals[0][0];
    }

    const cwd = std.Io.Dir.cwd();
    const dir = try cwd.openDir(io, path, .{ .iterate = true });
    defer dir.close(io);

    var files = try fs.Files.init(allocator, io, dir, .{ .show_detail = show_detail, .show_hidden = show_hidden, .sort_type = sort_type });
    defer files.deinit();

    if (show_detail) {
        try files.listDetail();
    } else {
        try files.list();
    }
}

test {
    _ = @import("files.zig");

    std.testing.refAllDecls(@This());
}
