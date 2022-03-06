#include <SUU-Runtime/Remote/RuntimeCapture.hpp>
#include <grpc++/grpc++.h>

#if defined(SUU_RUNTIME_PLATFORM_WINDOWS)
#include "Runtime-Platform/WindowsDesktop/Remote/RuntimeCapture.grpc.pb.h"
#elif defined(SUU_RUNTIME_PLATFORM_LINUX)
#include "Runtime-Platform/Linux/Remote/RuntimeCapture.grpc.pb.h"
#elif defined(SUU_RUNTIME_PLATFORM_ANDROID)
#include "Runtime-Platform/Android/Remote/RuntimeCapture.grpc.pb.h"
#else
#error "not supported yet."
#endif


using grpc::Channel;
using grpc::ClientContext;
using grpc::Status;


namespace remote {

class RuntimeCapture::Impl {
public:
    Impl()
        : m_channel(grpc::CreateChannel("192.168.11.4:50051", grpc::InsecureChannelCredentials()))
        , m_stub(SUU::Studio::RuntimeCapture::NewStub(m_channel))
    {}

    ~Impl() {}

    void SendImage(
        std::uint8_t* imageBuffer,
        int bufferWidth, int bufferHeight,
        int width, int height)
    {
        ClientContext context;
        SUU::Studio::SendImageResponse response;

        SUU::Studio::SendImageRequest request;

        std::string buffer(reinterpret_cast<char*>(imageBuffer), bufferWidth * bufferHeight * 4);
        request.set_buffer(buffer);
        request.set_buffer_width(bufferWidth);
        request.set_buffer_height(bufferHeight);
        request.set_width(width);
        request.set_height(height);

        auto writer = m_stub->SendImage(&context, &response);

        writer->Write(request);

        writer->WritesDone();
        auto status = writer->Finish();
        status;

        //// Act upon its status.
        //if (status.ok()) {
        //}
        //else {
        //    std::cout << status.error_code() << ": " << status.error_message()
        //        << std::endl;
        //    return "RPC failed";
        //}
    }

private:
    std::shared_ptr<Channel> m_channel;
    std::unique_ptr<SUU::Studio::RuntimeCapture::Stub> m_stub;
};

RuntimeCapture::RuntimeCapture()
    : m_impl(std::make_unique<Impl>())
{}

RuntimeCapture::~RuntimeCapture()
{}

void RuntimeCapture::SendImage(
    std::uint8_t* imageBuffer,
    int bufferWidth, int bufferHeight,
    int width, int height)
{
    m_impl->SendImage(
        imageBuffer,
        bufferWidth, bufferHeight,
        width, height);
}

}
