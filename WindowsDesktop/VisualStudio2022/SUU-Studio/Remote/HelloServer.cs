using Grpc.Core;
using System.Diagnostics;
using System.Threading.Tasks;

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
        static Server Server = new()
        {
            Services = { Greeter.BindService(new HelloServer()) },
            Ports = { new ServerPort("localhost", Port, ServerCredentials.Insecure) }
        };

        public static void Start()
        {
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
