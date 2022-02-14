#include <gtest/gtest.h>
#include <SUU-Runtime/SUU-Runtime.hpp>

TEST(Test_SUU_Runtime, PlatformName) {
    EXPECT_EQ("Android", suu::PlatformName());
}
