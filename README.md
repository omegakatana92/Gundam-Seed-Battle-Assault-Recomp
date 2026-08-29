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
