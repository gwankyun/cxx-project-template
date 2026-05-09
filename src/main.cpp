#include <fstream>

#include <boost/scope/defer.hpp>
#include <nlohmann/json.hpp>
#include <quill/Backend.h>
#include <quill/LogFunctions.h>
#include <quill/SimpleSetup.h>
#include <quill/sinks/ConsoleSink.h>

#include "common.hpp"
#include "compiler.h"

using json = nlohmann::json;

int main(int _argc, char* _argv[])
{
    // auto logger = quill::simple_logger();

    quill::Backend::start();
    BOOST_SCOPE_DEFER[&]
    {
        quill::Backend::stop();
    };

    auto console_sink = quill::Frontend::create_or_get_sink<quill::ConsoleSink>("sink_id_1");
    auto* logger = quill::Frontend::create_or_get_logger(
        "console", console_sink,
        quill::PatternFormatterOptions{"[%(time)] [%(caller_function:<8):%(line_number:>4)] %(message)",
                                       "%Y/%M/%d %H:%M:%S:%Qms", quill::Timezone::GmtTime});

    auto exe_path = getExecutablePath();
    quill::info(logger, "exe_path: {}", exe_path.string());

    int i{9};

    quill::info(logger, "compiler id     : {}", compiler::id());
    quill::info(logger, "compiler version: {}", compiler::version());
    quill::info(logger, "i: {}", i);

    std::ifstream f(exe_path.parent_path() / "test.json");
    json data = json::parse(f);

    bool happy = data["happy"];
    if (!(data.contains("list") && data["list"].is_array()))
    {
        return 1;
    }
    std::vector<int> lst = data["list"];
    quill::info(logger, "happy: {}", happy);
    for (auto& i : lst)
    {
        quill::info(logger, "i: {}", i);
    }

    return 0;
}
