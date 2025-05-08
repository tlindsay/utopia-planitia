# [Utopia Planitia Fleet Yards](https://memory-alpha.fandom.com/wiki/Utopia_Planitia_Fleet_Yards)
---

![](https://static.wikia.nocookie.net/startrek/images/c/c4/UtopiaPlanitia.jpg/revision/latest/scale-to-width-down/1000)

## Building Raspberry Pi Images

This flake supports building SD card images for Raspberry Pi and similar ARM-based devices.

### Using Remote Builders (Recommended)

The most reliable way to build ARM Linux images from macOS is using a remote Linux builder:

1. Setup the Linux builder:
   ```bash
   ./bin/setup-linux-builder
   ```
   This script:
   - Creates necessary SSH keys
   - Starts a Linux VM using the darwin.linux-builder feature from nixpkgs
   - Configures your system to use this VM for building aarch64-linux and armv7l-linux packages

2. Build a Raspberry Pi image:
   ```bash
   nix build .#nixosConfigurations.unimatrix01.config.system.build.sdImage
   ```

3. Flash the image to an SD card using `dd` or another flashing tool.

### GitHub Actions Builds

Alternatively, you can push changes to GitHub and let GitHub Actions build the images for you.
The images will be available as artifacts in the workflow runs.

## Systems

- **aarch64-darwin**: macOS systems
  - delta-flyer: Primary MacBook
  - fastbook: Work MacBook

- **aarch64-linux**: ARM64 Linux systems (Raspberry Pi 4, etc.)
  - unimatrix01-04: Compute modules for various purposes
  
- **armv7l-linux**: 32-bit ARM Linux systems
  - subspace-relay: Older Raspberry Pi

## TODO
- [ ] Fix Blink tab behavior
- [ ] Fix Blink cmdline completions
- [ ] Find a replacement for freddiehaddad/feline.lua
    - [incline](https://github.com/b0o/incline.nvim) 👈 Looks nice
    - [lualine](https://github.com/nvim-lualine/lualine.nvim) 👈 widely adopted
    - [windline](https://github.com/windwp/windline.nvim) 👈 Animated!
- [ ] Use more [snacks](https://github.com/folke/snacks.nvim)
    - [ ] Replace alpha with snacks dashboard
    - [ ] Use animations???
- [ ] Replace `unstable` overlay with `environmentPackages = [ … pkgs-unstable.git … ];` or whatever

