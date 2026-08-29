<<<<<<< HEAD
# GEMiniRecomp

This project contains C++ source generated from `GEMini.gba` and a native
runner linked to the upstream GBARecomp runtime.

## Build the generated source

Windows PowerShell:

```powershell
.\build.ps1
```

macOS or Linux:

```sh
./build.sh
```

The build creates `GEMiniRecomp.exe` and stages the compiler runtime DLLs beside
it. The runner verifies the ROM SHA-1 before
launching. The supplied ROM is expected at `../../games/GEMini.gba` relative to
the project executable directory, or can be selected with the runtime's `--rom`
option.

You must provide a legally obtained GBA BIOS. Place it at
`../gbarecomp/bios/gba_bios.bin` or pass its path with `--bios`.

The runtime and project layout follow
https://github.com/mstan/MinishCapRecomp/.
=======
# Gundam SEED: Battle Assault — Recomp

> **Work in Progress:** This recompilation is currently under active development. The core game functionality is working, but some graphical elements still need improvement.

A modern fan-made recompilation project for **Gundam SEED: Battle Assault**, originally released for the **Nintendo Game Boy Advance**.

## Current Status

The recompilation is currently **playable and most of the game is working properly**.

### Known Issues

The primary remaining issues are graphical:

* Battle UI graphics may display incorrectly.
* Character portraits may display incorrectly.
* Other graphical elements may require additional fixes and refinement.

**Audio, gameplay, and other core functionality are intended to remain unchanged while the remaining graphical issues are addressed.**

Contributors are welcome to investigate and improve the graphics implementation.

## ROM Required

This project **does not include the original game ROM or copyrighted assets**.

To play, you must provide your **own legally obtained ROM copy** of *Gundam SEED: Battle Assault*.

The original ROM must **not** be uploaded to this repository or included with releases.

## Features

* Game Boy Advance recompilation
* Currently playable / work in progress
* Core gameplay functionality working
* Audio functionality working
* Keyboard controls
* Fullscreen support
* Pause/resume
* Turbo/fast-forward
* Community contributions
* GitHub forking support
* Designed for modern systems

## Controls

| Keyboard Key    | Game Boy Advance Button / Function |
| --------------- | ---------------------------------- |
| **Arrow Keys**  | D-Pad                              |
| **X**           | A Button                           |
| **Z**           | B Button                           |
| **C**           | L Button                           |
| **V**           | R Button                           |
| **Enter**       | Start                              |
| **Right Shift** | Select                             |
| **Alt + Enter** | Fullscreen Toggle                  |
| **Shift + P**   | Pause / Resume                     |
| **Tab**         | Turbo / Fast-Forward               |

## Building From Source

This repository is intended to contain the source code and build files required to compile the recompilation.

### Requirements

* Git
* CMake
* A supported C/C++ compiler
* Required project dependencies
* Your own legally obtained ROM, if required by the build process

### Clone the Repository

```bash
git clone https://github.com/YOUR-USERNAME/Gundam-SEED-Battle-Assault-Recomp.git
cd Gundam-SEED-Battle-Assault-Recomp
```

### Configure the Build

```bash
cmake -S . -B build
```

### Build

```bash
cmake --build build --config Release
```

The resulting executable will be placed in the project's build output directory.

**The original game ROM is not included in this repository.**

## Contributing

**Contributions are welcome!**

Anyone interested in improving the recompilation can **fork this repository**, make changes, test their work, and submit a **Pull Request**.

The project is specifically open to contributions that can help resolve the remaining graphical issues.

### Areas That Need Improvement

* Battle UI rendering
* Character portrait rendering
* Other graphical compatibility issues
* Graphics accuracy and consistency
* Performance improvements
* Controller improvements
* Fullscreen improvements
* Linux compatibility
* Steam Deck compatibility
* Build-system improvements
* Documentation
* Accessibility improvements

### How to Contribute

1. **Fork** this repository.
2. Clone your fork.
3. Make your improvements.
4. Build and test the recompilation.
5. Commit your changes.
6. Push your changes to your fork.
7. Open a **Pull Request** back to this repository.

Please do not submit copyrighted ROM files, Gundam assets, anime assets, music, artwork, or other proprietary game material.

See `CONTRIBUTING.md` for additional contribution guidelines.

## Nintendo Switch 2

If technically feasible, compatibility or support for the **Nintendo Switch 2** may be considered where applicable.

This project is **not affiliated with, endorsed by, or sponsored by Nintendo, Bandai Namco, Sunrise, or the other rights holders associated with Gundam SEED: Battle Assault**.

## Copyright

**Mobile Suit Gundam SEED**, Gundam, *Gundam SEED: Battle Assault*, its characters, mobile suits, names, artwork, music, trademarks, and other intellectual property remain the property of their respective copyright and trademark holders.

This is an independent fan-made recompilation project.

No original ROM files or copyrighted game assets are distributed with this project.

**All rights to the original game and its associated intellectual property remain with their respective owners.**

## Fullscreen

Press **Alt + Enter** to toggle between windowed and fullscreen modes.

## Disclaimer

This project is currently a **work in progress**. While the core game is functional, graphical issues remain, particularly with the **battle UI and character portraits**.

This project does not distribute the original game ROM or copyrighted game assets.

Users must provide their own legally obtained ROM.

This project is an independent fan-made recompilation and is **not affiliated with or endorsed by Nintendo, Bandai Namco, Sunrise, or other rights holders associated with the original game.**

>>>>>>> 4699fa3f98968b375cd1379c3b6578efd82b493c
