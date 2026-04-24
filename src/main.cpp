#define DOCTEST_CONFIG_IMPLEMENT
#include "compiler.h"
#include <spdlog/spdlog.h>

int main(int _argc, char* _argv[])
{
    // spdlog::set_pattern("[%Y-%m-%d %T.%e] [%^%l%$] [t:%6t] [p:%6P] [%-8!!:%4#] %v");
    spdlog::set_pattern("[%C-%m-%d %T.%e] [%^%L%$] [%-8!!:%4#] %v");

    int i = 9;

    SPDLOG_INFO("compiler id     : {}", compiler::id());
    SPDLOG_INFO("compiler version: {}", compiler::version());
    SPDLOG_INFO("i: {}", i);

    return 0;
}
