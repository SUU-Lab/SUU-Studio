#pragma once

#include <memory>

namespace remote {

class RuntimeCapture {
public:
    RuntimeCapture();
    ~RuntimeCapture();

    void SendImage(
        std::uint8_t* imageBuffer,
        int bufferWidth, int bufferHeight,
        int width, int height);

private:
    class Impl;
    std::unique_ptr<Impl> m_impl;
};

}
