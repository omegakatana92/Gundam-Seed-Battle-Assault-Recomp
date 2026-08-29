#include "runtime.h"

#include <filesystem>
#include <cstdlib>

static void set_default_environment(const char* name, const char* value) {
    if (std::getenv(name)) return;
#if defined(_WIN32)
    _putenv_s(name, value);
#else
    setenv(name, value, 0);
#endif
}

int main(int argc, char** argv) {
    std::error_code path_error;
    const std::filesystem::path executable_path =
        std::filesystem::absolute(argv[0], path_error);
    if (!path_error && executable_path.has_parent_path()) {
        std::filesystem::current_path(executable_path.parent_path(), path_error);
    }

    set_default_environment("GBARECOMP_PRESENT_IN_PLACE", "0");
    set_default_environment("GBARECOMP_AUDIO_DIRECT", "0");
    set_default_environment("GBARECOMP_AUDIO_SHADOW", "0");
    set_default_environment("GBARECOMP_SELFHEAL_RECOMPILE", "0");
    set_default_environment("GBARECOMP_FORCE_INTERP", "1");
    set_default_environment("GBARECOMP_BIOS_HLE", "1");
    set_default_environment("GBARECOMP_NO_VSYNC", "1");

    gbarecomp::RunOptions options;
    options.builtin_game_name = "GundamSeedBA";
    options.builtin_rom_sha1 = "8287d3d336d94a85c5cb22da0fd84918199197e1";
    options.mod_game_id = "gundam_seed_ba";
    options.launcher_region = "USA";
    options.launcher_game_config = "game.toml";
    options.launcher_rom_cache_filename = "gundam_rom.cfg";
    options.launcher_bios_cache_filename = "gundam_bios.cfg";
    options.launcher_save_path = "GundamSeedBA.sav";
    return gbarecomp::run_game(argc, argv, options);
}