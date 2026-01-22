# zlist

A modern, high-performance alternative to ls, written in Zig.

**(The timing is just not right. I need more time to work on this tiny project.)**

## Installation

### Build from source

```bash
git clone git@github.com:here-Leslie-Lau/zlist.git
zig build -Doptimize=[ReleaseFast, ReleaseSmall, ReleaseSafe]
```

Then, move the compiled binary to a directory in your PATH, e.g., `/usr/local/bin`.

At the end, run `ls`.
