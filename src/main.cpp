#include <fstream>
#include <iostream>

#include "compiler.h"
#include <common.hpp>
#include <nlohmann/json.hpp>
#include <spdlog/spdlog.h>

using json = nlohmann::json;

int main(int _argc, char* _argv[])
{
    // spdlog::set_pattern("[%Y-%m-%d %T.%e] [%^%l%$] [t:%6t] [p:%6P] [%-8!!:%4#] %v");
    spdlog::set_pattern("[%C-%m-%d %T.%e] [%^%L%$] [%-8!!:%4#] %v");

    auto exe_path = getExecutablePath();
    SPDLOG_INFO("exe_path: {}", exe_path.string());

    int i = 9;

    SPDLOG_INFO("compiler id     : {}", compiler::id());
    SPDLOG_INFO("compiler version: {}", compiler::version());
    SPDLOG_INFO("i: {}", i);

    std::ifstream f(exe_path.parent_path() / "test.json");
    json data = json::parse(f);

    bool happy = data["happy"];
    std::vector<int> lst = data["list"];
    SPDLOG_INFO("happy: {}", happy);
    for (auto& i : lst)
    {
        SPDLOG_INFO("i: {}", i);
    }

    return 0;
}
