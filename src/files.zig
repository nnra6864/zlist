const std = @import("std");
const mem = std.mem;

const file = @import("file.zig");

pub const Files = struct {
    const Self = @This();

    allocator: mem.Allocator,
    io: std.Io,
    items: std.ArrayList(file.File),
    stdout: *std.Io.Writer,
    handle: std.Io.File.Handle,

    /// init a Files from a directory
    pub fn init(allocator: mem.Allocator, io: std.Io, dir: std.Io.Dir) !Self {
        // stdout
        var stdout_buf: [1024]u8 = undefined;
        const stdout_file = std.Io.File.stdout();
        var stdout_writer = stdout_file.writer(io, &stdout_buf);

        const stdout = &stdout_writer.interface;

        var files = try std.ArrayList(file.File).initCapacity(allocator, 32);

        var it = dir.iterate();
        while (try it.next(io)) |entry| {
            const fs = file.File.init(&entry) orelse continue;
            try files.append(allocator, fs);
        }

        // sort files by name
        // mem.sortUnstable(file.File, files.items, {}, file.File.nameLessThan);

        return .{
            .allocator = allocator,
            .io = io,
            .items = files,
            .stdout = stdout,
            .handle = stdout_file.handle,
        };
    }

    pub fn deinit(self: *Self) void {
        self.items.deinit(self.allocator);
    }

    pub fn list(self: Self) !void {
        const max_display_len = self.getMaxDisplayLen();
        const term_width = self.getTerminalWidth();
        const col_width = max_display_len + 2; // 2 spaces padding
        var cols = term_width / col_width;
        if (cols < 1) {
            cols = 1;
        }

        for (self.items.items, 0..) |val, i| {
            const icon = val.getIcon();
            try self.stdout.print("  {s}{s} {s:<[3]}\x1b[0m", .{ val.getColor(), icon, val.name, max_display_len - icon.len + 1 });

            // make sure to print newline after each row
            if ((i + 1) % cols == 0) {
                try self.stdout.print("\n", .{});
            }
        }

        try self.stdout.print("\n", .{});
        try self.stdout.flush();
    }

    /// get terminal width
    inline fn getTerminalWidth(self: Self) usize {
        var winsize = std.mem.zeroes(std.posix.winsize);
        if (std.c.ioctl(self.handle, std.c.T.IOCGWINSZ, @intFromPtr(&winsize)) == 0) {
            return winsize.col;
        }

        // default width
        return 80;
    }

    /// get max display length of file names, including icons
    inline fn getMaxDisplayLen(self: Self) usize {
        var max_len: usize = 0;
        for (self.items.items) |val| {
            const curr_len = val.name.len + val.getIcon().len;

            if (curr_len > max_len) {
                max_len = curr_len;
            }
        }

        return max_len;
    }
};
