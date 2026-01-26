const std = @import("std");
const mem = std.mem;

pub const File = struct {
    const Self = @This();
    is_dir: bool,
    is_exec: bool,
    is_hidden: bool,
    name: []const u8,

    size: u64,
    /// Last modification time in nanoseconds, relative to UTC 1970-01-01.
    mtime: ?std.Io.Timestamp,

    pub const Options = struct {
        /// show detail mode
        show_detail: bool = false,
        /// show hidden files
        show_hidden: bool = false,
        sub_path: []const u8 = ".",
    };

    /// Initialize a File from a directory entry.
    /// Return null if the file should be skipped (e.g., hidden files when not showing hidden).
    pub inline fn init(
        io: std.Io,
        entry: *const std.Io.Dir.Entry,
        dir: *const std.Io.Dir,
        opt: Options,
    ) !?Self {
        const is_dir: bool = (entry.kind == .directory);
        const is_hidden: bool = (entry.name[0] == '.');

        if (!opt.show_hidden and is_hidden) {
            return null;
        }

        var file: Self = .{
            .is_hidden = is_hidden,
            .is_dir = is_dir,
            .is_exec = false,
            .name = entry.name,
            .size = 0,
            .mtime = null,
        };

        if (opt.show_detail) {
            // read more file details
            const stat = try dir.statFile(io, opt.sub_path, .{});
            file.size = stat.size;
            file.mtime = stat.mtime;
        }

        return file;
    }

    pub fn nameLessThan(_: void, lhs: Self, rhs: Self) bool {
        return std.ascii.orderIgnoreCase(lhs.name, rhs.name) == .lt;
    }

    const Color = struct {
        const reset = "\x1b[0m";
        const light_blue = "\x1b[94m";
        const light_green = "\x1b[92m";
        const cyan = "\x1b[36m";
        const light_magenta = "\x1b[95m";
        const light_yellow = "\x1b[93m";
        const red = "\x1b[31m";
        const white = "\x1b[37m";
    };

    pub inline fn getColor(self: Self) []const u8 {
        // TODO: add more colors based on file type
        if (self.is_dir) {
            // blue (directory)
            return Color.light_blue;
        } else {
            // default file color
            return Color.light_yellow;
        }
    }
};
