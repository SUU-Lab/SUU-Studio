#include <SUU-Runtime/Remote/Hello.hpp>
#include <grpc++/grpc++.h>
#include "Runtime-Platform/WindowsDesktop/Remote/Hello.grpc.pb.h"

using grpc::Channel;
using grpc::ClientContext;
using grpc::Status;


namespace remote {

// Assembles the client's payload, sends it and presents the response back
// from the server.
std::string SayHello(const std::string& user)
{
    std::shared_ptr<Channel> channel = grpc::CreateChannel("localhost:50051", grpc::InsecureChannelCredentials());
    std::unique_ptr<Greeter::Stub> stub_(Greeter::NewStub(channel));

    // Data we are sending to the server.
    HelloRequest request;
    request.set_name(user);

    // Container for the data we expect from the server.
    HelloReply reply;

    // Context for the client. It could be used to convey extra information to
    // the server and/or tweak certain RPC behaviors.
    ClientContext context;

    // The actual RPC.
    Status status = stub_->SayHello(&context, request, &reply);

    // Act upon its status.
    if (status.ok()) {
        return reply.message();
    }
    else {
        std::cout << status.error_code() << ": " << status.error_message()
            << std::endl;
        return "RPC failed";
    }
}

}
