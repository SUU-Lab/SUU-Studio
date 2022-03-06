using Grpc.Core;
using SUU.Studio;
using SUU_Studio.ViewModel;
using System.Diagnostics;
using System.Threading.Tasks;
using System.Windows.Threading;

namespace SUU_Studio.Remote
{
    class HelloServer : Greeter.GreeterBase
    {
        public override Task<HelloReply> SayHello(HelloRequest request, ServerCallContext context)
        {
            Debug.Print($"SayHello({request.Name})");
            return Task.FromResult(new HelloReply { Message = "Hello " + request.Name });
        }

        static int Port = 50051;
        static Server Server;

        public static void Start(RuntimeCaptureImageViewModel runtimeCaptureImage, Dispatcher dispatcher)
        {
            Server = new()
            {
                Services = {
                Greeter.BindService(new HelloServer()),
                RuntimeCapture.BindService(new RuntimeCaptureService(runtimeCaptureImage, dispatcher))
            },
                Ports = { new ServerPort("192.168.11.4", Port, ServerCredentials.Insecure) }
            };
            Server.Start();

            Debug.Print("Greeter server listening on port " + Port);
            Debug.Print("Press any key to stop the server...");
        }

        public static void Shutdown()
        {
            Debug.Print("Greeter server stopping...");
            
            Server.ShutdownAsync().Wait();

            Debug.Print("Greeter server stopped");
        }
    }
}
