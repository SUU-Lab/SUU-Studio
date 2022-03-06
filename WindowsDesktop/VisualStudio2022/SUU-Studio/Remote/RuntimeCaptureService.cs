using Grpc.Core;
using SUU.Studio;
using SUU_Studio.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Threading;

namespace SUU_Studio.Remote
{
    class RuntimeCaptureService : RuntimeCapture.RuntimeCaptureBase
    {
        public const int PACKET_SIZE_MAX = 1024 * 1024;

        RuntimeCaptureImageViewModel RuntimeCaptureImageViewModel { get; set; }
        Dispatcher Dispatcher { get; set; }

        public RuntimeCaptureService(RuntimeCaptureImageViewModel runtimeCaptureImage, Dispatcher dispatcher)
        {
            RuntimeCaptureImageViewModel = runtimeCaptureImage;
            Dispatcher = dispatcher;
        }

        public override async Task<SendImageResponse> SendImage(IAsyncStreamReader<SendImageRequest> requestStream, ServerCallContext context)
        {
            SendImageResponse result = new SendImageResponse();
            byte[] imageBuffer = null;
            int width = 0, height = 0;
            int buffer_width = 0, buffer_height = 0;

            using (Mutex mutex = new Mutex(true))
            {
                while (await requestStream.MoveNext())
                {
                    var request = requestStream.Current;

                    Array.Resize(ref imageBuffer, request.Buffer.Length);

                    request.Buffer.CopyTo(imageBuffer, result.ReceivedBytes);

                    result.ReceivedBytes += request.Buffer.Length;

                    width = request.Width;
                    height = request.Height;
                    buffer_width = request.BufferWidth;
                    buffer_height = request.BufferHeight;
                }
            }

            if (imageBuffer != null && imageBuffer.Length > 0)
            {
                Dispatcher.Invoke(() =>
                {
                    RuntimeCaptureImageViewModel.UpdateImage(
                        imageBuffer,
                        buffer_width, buffer_height,
                        width, height);
                });
            }

            return result;
        }
    }
}
