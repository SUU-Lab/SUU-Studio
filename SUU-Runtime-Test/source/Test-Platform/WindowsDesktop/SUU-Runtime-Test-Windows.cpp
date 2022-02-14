#include "pch.hpp"
#include <SUU-Runtime/SUU-Runtime.hpp>

TEST(Test_SUU_Runtime, PlatformName) {
    EXPECT_EQ("WindowsDesktop", suu::PlatformName());
}
