#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include "compiler.h"
#include <doctest/doctest.h>

TEST_CASE("testing compiler")
{
#ifdef _MSC_VER
    CHECK(compiler::id() == "MSVC");
#elif defined(__clang__)
    CHECK(compiler::id() == "Clang");
#elif defined(__GNUC__)
#else
#endif
}
