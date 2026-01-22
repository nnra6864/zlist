# zlist [![](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge.svg)](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge) || [![](https://img.shields.io/badge/zig-0.16.0_dev.2261+d6b3dd25a-green.svg)](https://img.shields.io/badge/zig-0.16.0_dev.2261+d6b3dd25a-green)

A modern, high-performance alternative to ls, written in Zig.

**(The timing is just not right. I need more time to work on this tiny project.)**

## Screenshots

## Features

## Installation

### Download precompiled binary

**TODO**

You can download the latest precompiled binary from the [releases page]().

### Build from source

```bash
git clone git@github.com:here-Leslie-Lau/zlist.git && cd zlist
zig build -Doptimize=[ReleaseFast, ReleaseSmall, ReleaseSafe]
```

Then, move the compiled binary (In `zig-out/bin`) to a directory in your PATH, e.g., `/usr/local/bin`.

At the end, run `ls`.

## Usage

## Contributing

Contributions are welcome! Please feel free to:
- Report bugs via [Issues](https://github.com/here-Leslie-Lau/zlist/issues)
- Submit [Pull Requests](https://github.com/here-Leslie-Lau/zlist/pulls)
- Suggest new features or improvements

## Roadmap

- [ ] Support more options (e.g., -a, -l, -t)
- [ ] Support specific path to list
- [ ] Precompile binaries for major platforms
- [ ] Support options

## License

This project is open source. See the LICENSE file for details.
