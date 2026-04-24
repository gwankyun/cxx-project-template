#include "compiler.h"
#include "compiler_info.h"

namespace compiler
{
    std::string id()
    {
        return CXX_COMPILER_ID;
    }

    std::string version()
    {
        return CXX_COMPILER_VERSION;
    }
} // namespace compiler
