const std = @import("std");
const ssl = @import("bearssl.zig");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("example", "build.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);

    ssl.linkBearSSL(".", exe, target);
    exe.install();
}

pub fn main() !void {
    const trust_anchor = ssl.TrustAnchorCollection.init(std.heap.c_allocator);
    errdefer trust_anchor.deinit();

    var x509 = ssl.x509.Minimal.init(trust_anchor);
    var client = ssl.Client.init(x509.getEngine());
    // $ zig build -Dtarget=x86_64-linux-gnu
    // Build Dependencies...lld: error: undefined symbol: getentropy
    // >>> referenced by sysrng.c:154 (BearSSL/src/rand/sysrng.c:154)
    // >>> did you mean: getentropy
}
