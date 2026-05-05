#pragma once
#include <filesystem>
#include <vector>
#include <whereami.h>

namespace fs = std::filesystem;

inline fs::path getExecutablePath()
{
    fs::path result;

    auto length = wai_getExecutablePath(nullptr, 0, nullptr);
    if (length <= 0)
    {
        return result;
    }
    std::vector<char> path(length + 1, '\0');
    wai_getExecutablePath(path.data(), length, nullptr);
    result = path.data();
    return result;
}
