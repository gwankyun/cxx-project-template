#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include <fstream>

#include <boost/scope/defer.hpp>
#include <doctest/doctest.h>
#include <nlohmann/json.hpp>

#include "common.hpp"
#include "compiler.h"


using json = nlohmann::json;

TEST_CASE("testing compiler")
{
#if defined(_MSC_VER) && defined(__clang__)
    CHECK(compiler::id() == "Clang");
#elif defined(_MSC_VER)
    CHECK(compiler::id() == "MSVC");
#elif defined(__clang__)
    CHECK(compiler::id() == "Clang");
#elif defined(__GNUC__)
    CHECK(compiler::id() == "GCC");
#else
#endif
}

TEST_CASE("testing nlohmann_json")
{
    auto exe_path = getExecutablePath();
    std::ifstream f(exe_path.parent_path() / "test.json");
    json data = json::parse(f);

    bool happy = data["happy"];
    CHECK(happy == true);
    auto lst = data["list"];
    CHECK(lst.is_array());
    if (lst.is_array())
    {
        std::vector<int> v = lst;
        CHECK(lst == std::vector<int>{1, 0, 2});
    }
}

TEST_CASE("testing scope_exit")
{
    int value = 1;
    {
        value = 2;
        BOOST_SCOPE_DEFER[&]
        {
            value = 9;
        };
    }
    CHECK(value == 9);
}
