const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    {
        // setup exe
        const exe = b.addExecutable(.{
            .name = "ls",
            .root_module = mod,
        });

        b.installArtifact(exe);
    }

    {
        // setup test
        const tests = b.addTest(.{
            .root_module = mod,
        });

        const test_cmd = b.addRunArtifact(tests);
        test_cmd.step.dependOn(b.getInstallStep());
        const test_step = b.step("test", "Run the tests");
        test_step.dependOn(&test_cmd.step);
    }
}
